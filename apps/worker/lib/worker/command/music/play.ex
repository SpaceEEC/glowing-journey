defmodule Worker.Command.Music.Play do
  use Worker.Command

  alias Rpc.LavaLink
  alias Rpc.LavaLink.Track

  @impl true
  def description(), do: Template.play_description()
  @impl true
  def usages(), do: Template.play_usages()
  @impl true
  def examples(), do: Template.play_examples()
  @impl true
  def disabled(), do: Template.music_disabled()


  @impl true
  def triggers(), do: ["play", "soundcloud"]

  @impl true
  def required() do
    [
      MiddleWare.GuildOnly,
      MiddleWare.FetchGuild,
      {MiddleWare.Connected, :play},
      {MiddleWare.DJ, &MiddleWare.OwnerOnly.owner?/1},
      {MiddleWare.HasPermissions,
       {[:connect, :view_channel, :speak],
        fn %{assigns: %{guild: %{voice_states: voice_states}}, message: %{author: %{id: user_id}}} ->
          voice_states[user_id].channel_id
        end, :self}}
    ]
  end

  @impl true
  def call(%{args: []} = command, _) do
    set_response(command, content: Template.generic_no_args())
  end

  def call(
        %{
          args: args,
          message: %{author: author, guild_id: guild_id, channel_id: channel_id},
          shard_id: shard_id,
          trigger: trigger,
          assigns: %{guild: %{voice_states: voice_states}}
        } = command,
        _
      ) do
    query = Enum.join(args, " ")

    response =
      query
      |> maybe_apply_prefix(trigger)
      |> LavaLink.resolve_identifier_and_fetch_tracks(author)
      |> case do
        {:error, error} ->
          # TODO: handle this
          raise inspect(error)

        [] ->
          [content: Template.play_nothing_found()]

        track_or_tracks ->
          unless Map.get(voice_states, Worker.Commands.get_user_id(), %{channel_id: nil}).channel_id do
            Rpc.Gateway.voice_state_update(shard_id, guild_id, voice_states[author.id].channel_id)
          end

          LavaLink.register(guild_id, channel_id, shard_id)

          case LavaLink.play(guild_id, track_or_tracks) do
            {true, _} ->
              [content: Template.play_start()]

            {false, tracks} ->
              # TODO: show that more than one got queued
              track = if is_list(tracks), do: List.first(tracks), else: tracks
              [embed: Track.to_embed(track, :add)]
          end
      end

    set_response(command, response)
  end

  defp maybe_apply_prefix(query, trigger)

  defp maybe_apply_prefix(query, "soundcloud") do
    "scsearch:#{query}"
  end

  defp maybe_apply_prefix(query, _trigger) do
    query
  end
end
