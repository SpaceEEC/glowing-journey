defmodule LavaLink.Player do
  use ExLink.Player

  alias ExLink.{Connection, Message}

  alias Rpc.{Rest, Gateway}
  alias LavaLink.Track
  alias Util.Config.Guild
  alias Util.Locale
  alias Util.Locale.Template

  require Rpc.Sentry

  # General info
  defstruct client: nil,
            guild_id: nil,
            channel_id: nil,
            shard_id: nil,
            # State
            volume: 100,
            queue: :queue.new(),
            position: 0,
            paused: true,
            loop: false,
            force_embed_update: false,
            message: nil

  def name(), do: __MODULE__

  def opts() do
    %{
      url: "ws://" <> Application.fetch_env!(:lavalink, :lavalink_authority),
      authorization: Application.fetch_env!(:lavalink, :lavalink_authorization),
      # TODO: get automatically
      shard_count: 1,
      user_id: Application.fetch_env!(:lavalink, :user_id)
    }
  end

  def send_message(message) do
    Connection.send(__MODULE__.name(), message)
  end

  # Debug thing, hopefully this helps.
  # Nothing like debuggin in prod.
  def init(client, guild_id) do
    try do
      _init(client, guild_id)
    rescue
      e ->
        Sentry.capture_exception(e,
          stacktrace: __STACKTRACE__,
          tags: %{
            guild_id: guild_id
          }
        )

        {:stop, e}
    end
  end

  defp _init(client, guild_id)
       when not is_nil(client) and not is_nil(guild_id) do
    Rpc.Sentry.debug(
      "[---------------------------------------] INIT #{inspect(self())} #{guild_id} [---------------------------------------]",
      "player"
    )

    state = %__MODULE__{
      client: client,
      guild_id: guild_id,
      volume: Guild.get_volume(guild_id, 100),
      # TODO: calculate manually
      shard_id: 0
    }

    unless state.volume == 100 do
      state.volume
      |> Message.volume(guild_id)
      |> send_message()
    end

    {:ok, state}
  end

  def handle_call({:command, command}, _from, state) do
    {command, data} =
      case command do
        {command, data} ->
          data = if is_tuple(data), do: Tuple.to_list(data), else: [data]
          {command, data}

        command when is_atom(command) ->
          {command, []}
      end

    reply =
      {:reply, _, %__MODULE__{queue: queue}} = apply(__MODULE__.Command, command, data ++ [state])

    Rpc.Sentry.info("#{command} -> #{:queue.len(queue)}", "player")

    reply
  end

  def handle_call({:register, data}, _from, state) do
    {channel_id, shard_id} = data

    state = %__MODULE__{state | channel_id: channel_id, shard_id: shard_id}

    {:reply, :ok, state}
  end

  # Global stats and stuff
  def handle_dispatch(data, nil) do
    require Logger
    Logger.debug(fn -> "Stats: #{inspect(data)}" end)
  end

  def handle_dispatch(data, %__MODULE__{force_embed_update: true} = state) do
    state = set_embed(state)
    state = %__MODULE__{state | force_embed_update: false}
    handle_dispatch(data, state)
  end

  # Paused handler
  def handle_dispatch(
        %{
          "op" => "playerUpdate",
          "state" => %{
            # "time" => time,
            "position" => same_position
          }
        } = event,
        %__MODULE__{
          position: same_position,
          paused: paused
        } = state
      ) do
    Rpc.Sentry.debug("playerUpdate #{inspect(event)}", "player")

    state =
      if paused do
        # Already known as paused, do nothing
        state
      else
        set_embed(%__MODULE__{state | paused: true})
      end

    {:noreply, state}
  end

  # Resuming
  def handle_dispatch(
        %{"op" => "playerUpdate"} = data,
        %__MODULE__{paused: true, queue: queue, guild_id: guild_id, shard_id: shard_id} = state
      ) do
    case :queue.peek(queue) do
      {:value, _track} ->
        state = set_embed(%__MODULE__{state | paused: false})

        handle_dispatch(data, state)

      :empty ->
        IO.inspect(state)

        Rpc.Sentry.error(
          "Received player update for guild #{guild_id} (#{shard_id}) but nothing is queued up! (Did the player crash?)",
          "player"
        )

        Sentry.capture_message("Empty player received player update.")

        Gateway.voice_state_update(shard_id, guild_id, nil)

        {:noreply, state}
    end
  end

  # Running
  def handle_dispatch(
        %{
          "op" => "playerUpdate",
          "state" => %{
            # "time" => time,
            "position" => new_position
          }
        } = event,
        %__MODULE__{paused: false} = state
      ) do
    Rpc.Sentry.debug("playerUpdate #{inspect(event)}", "player")

    state = %__MODULE__{state | position: new_position}

    {:noreply, state}
  end

  def handle_dispatch(
        %{
          "op" => "event",
          "reason" => reason,
          "type" => "TrackEndEvent"
        },
        %__MODULE__{queue: queue, guild_id: guild_id, shard_id: shard_id} = state
      ) do
    track =
      case :queue.peek(queue) do
        {:value, track} -> track
        :empty -> nil
      end

    base = "TrackEndEvent: (#{guild_id}) #{reason} "

    message =
      if track do
        position = Track.format_milliseconds(track.position)
        length = Locale.localize(Locale.EN, Track.to_length(track))
        base <> "#{position} / #{length}"
      else
        base <> "no track data available"
      end

    Rpc.Sentry.debug(message, "player")

    extra_content = if track, do: [embed: Track.to_embed(track, :end)], else: []
    state = set_message(state, [{:content, "Ended `#{reason}`"} | extra_content])
    state = %__MODULE__{state | position: 0, paused: true, message: nil}

    state =
      if reason == "REPLACED" do
        state
      else
        %__MODULE__{queue: queue} = state = handle_queue(state)

        case :queue.peek(queue) do
          {:value, track} ->
            track.track
            |> Message.play(guild_id)
            |> send_message()

            state

          :empty ->
            Gateway.voice_state_update(shard_id, guild_id, nil)
            %__MODULE__{state | queue: :queue.new()}
        end
      end

    {:noreply, state}
  end

  def handle_dispatch(
        %{
          "op" => "event",
          "type" => "WebSocketClosedEvent",
          "reason" => reason,
          "byRemote" => by_remote,
          "code" => code
        },
        %{guild_id: guild_id} = state
      ) do
    Rpc.Sentry.warn(
      """
      WebSocket closed:
      Code: #{code}
      Reason: #{reason}
      By remote: #{by_remote}
      """,
      "player"
    )

    Rpc.Sentry.debug(
      "[---------------------------------------] STOP #{inspect(self())} #{guild_id} [---------------------------------------]",
      "player"
    )

    {:stop, :normal, state}
  end

  def handle_dispatch(data, state) do
    Rpc.Sentry.debug("Received: #{inspect(data)}", "player")

    {:noreply, state}
  end

  # Removes the first element, if loop is enabled insterts it at the end again
  defp handle_queue(%__MODULE__{loop: loop, queue: queue} = state) do
    queue =
      case :queue.out(queue) do
        {{:value, track}, queue} ->
          if loop do
            :queue.in(track, queue)
          else
            queue
          end

        {:empty, queue} ->
          queue
      end

    %__MODULE__{state | queue: queue}
  end

  def set_embed(%__MODULE__{queue: queue, paused: paused, loop: loop} = state) do
    case :queue.peek(queue) do
      {:value, track} ->
        type = if paused, do: :pause, else: :play

        embed = Track.to_embed(track, type)

        embed =
          if loop do
            Map.update!(embed, :description, &Template.track_loop/1)
          else
            embed
          end

        set_message(state, embed: embed)

      :empty ->
        state
    end
  end

  def set_message(%__MODULE__{channel_id: nil} = state, message) do
    Rpc.Sentry.error(
      "Tried to set message but no channel was registered: #{inspect(message)}",
      "player"
    )

    Sentry.capture_message("Updating player message failed.")

    state
  end

  def set_message(%{message: nil, guild_id: guild_id, channel_id: channel_id} = state, data) do
    locale = Locale.fetch!(guild_id)
    data = Locale.localize_response(data, locale)

    case Rest.create_message(channel_id, data) do
      {:ok, %Crux.Structs.Message{} = message} ->
        %__MODULE__{state | message: message}

      {:error, error} ->
        Rpc.Sentry.error(
          "Setting a new message failed #{inspect(error)} #{inspect(data)}",
          "player"
        )

        Sentry.capture_message("Updating player message failed.")

        state
    end
  end

  def set_message(%{guild_id: guild_id, message: message} = state, data) do
    locale = Locale.fetch!(guild_id)
    data = Locale.localize_response(data, locale)

    case Rest.edit_message(message, data) do
      {:ok, %Crux.Structs.Message{} = message} ->
        %__MODULE__{state | message: message}

      {:error, error} ->
        case error do
          # Unknown message code    \/
          %Crux.Rest.ApiError{code: 10008} ->
            Rpc.Sentry.warn("Message deleted, sending a new one...", "player")

            %__MODULE__{state | message: nil}
            |> set_message(data)

          _ ->
            Rpc.Sentry.error(
              "Setting an old message failed #{inspect(error)} #{inspect(data)}",
              "player"
            )

            Sentry.capture_message("Updating player message failed.")

            state
        end
    end
  end
end
