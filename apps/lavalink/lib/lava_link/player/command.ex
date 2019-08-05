defmodule LavaLink.Player.Command do
  # # General info
  # defstruct client: nil,
  #           guild_id: nil,
  #           channel_id: nil,
  #           shard_id: nil,
  #           # State
  #           queue: :queue.new(),
  #           position: 0,
  #           paused: true,
  #           loop: false,
  #           message: nil

  alias ExLink.Message
  alias LavaLink.Player

  def play([first | _] = tracks, %Player{queue: queue, guild_id: guild_id} = state) do
    start = :queue.is_empty(queue)

    queue = Enum.reduce(tracks, queue, &:queue.in/2)

    if start do
      Message.play(first.track, guild_id)
      |> Player.send_message()
    end

    state = %Player{state | queue: queue}

    {:reply, {start, tracks}, state}
  end

  def skip(count, %Player{queue: queue, guild_id: guild_id} = state)
      when count > 0 do
    # Avoid badarg error
    count = min(count, :queue.len(queue))

    {skipped, queue} = :queue.split(count, queue)

    [first | _] = skipped = :queue.to_list(skipped)

    # Add currently played track again, because the "song ended" handler expects it there
    queue = :queue.in_r(first, queue)

    state = %Player{state | queue: queue}

    Message.stop(guild_id)
    |> Player.send_message()

    {:reply, skipped, state}
  end

  def remove(position, count, %Player{queue: queue} = state)
      when position > 1 and count > 0 do
    length = :queue.len(queue)

    # Nothing to remove
    if position > length do
      {:reply, nil, state}
    else
      {first, rest} = :queue.split(position - 1, queue)
      count = min(count, :queue.len(rest))
      {dropped, rest} = :queue.split(count, rest)

      tracks = :queue.to_list(dropped)

      queue = :queue.join(first, rest)
      state = %Player{state | queue: queue}
      {:reply, tracks, state}
    end
  end

  def loop(%Player{loop: loop} = state) do
    {:reply, loop, state}
  end

  def loop(new_state, %Player{loop: loop} = state)
      when is_boolean(new_state) do
    change = loop != new_state

    state = %Player{state | loop: new_state, force_embed_update: change}

    {:reply, change, state}
  end

  def shuffle(%Player{queue: queue} = state) do
    queue =
      queue
      |> :queue.to_list()
      |> Enum.shuffle()
      |> :queue.from_list()

    state = %Player{state | queue: queue}

    {:reply, :ok, state}
  end

  def pause(%Player{paused: true} = state) do
    {:reply, false, state}
  end

  def pause(%Player{paused: false, guild_id: guild_id} = state) do
    true
    |> Message.pause(guild_id)
    |> Player.send_message()

    {:reply, true, state}
  end

  def resume(%Player{paused: false} = state) do
    {:reply, false, state}
  end

  def resume(%Player{paused: true, guild_id: guild_id} = state) do
    false
    |> Message.pause(guild_id)
    |> Player.send_message()

    {:reply, true, state}
  end

  def now_playing(%Player{queue: queue, position: position} = state) do
    track =
      case :queue.peek(queue) do
        {:value, track} ->
          # Set current track's position
          %{track | position: position}

        :empty ->
          nil
      end

    {:reply, track, state}
  end

  def queue(%Player{queue: queue, position: position} = state) do
    queue =
      queue
      |> :queue.to_list()
      # Set current track's position
      |> List.update_at(0, &Map.put(&1, :position, position))

    {:reply, queue, state}
  end

  def volume(%Player{volume: volume} = state) do
    {:reply, volume, state}
  end

  def volume(volume, %Player{guild_id: guild_id} = state)
      when volume in 0..1000 do
    Message.volume(volume, guild_id)
    |> Player.send_message()

    state = %Player{state | volume: volume}
    {:reply, :ok, state}
  end

  def volume(_volume, %Player{} = state) do
    {:reply, :error, state}
  end
end
