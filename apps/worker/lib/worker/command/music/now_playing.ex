defmodule Worker.Command.Music.NowPlaying do
  use Worker.Command

  alias Rpc.LavaLink
  alias Rpc.LavaLink.Track

  @impl true
  def description(), do: Template.nowplaying_description()
  @impl true
  def usages(), do: Template.nowplaying_usages()
  @impl true
  def examples(), do: Template.nowplaying_examples()

  @impl true
  def triggers(), do: ["nowplaying", "np"]
  @impl true
  def required(), do: [MiddleWare.GuildOnly, {MiddleWare.Connected, :now_playing}]

  @impl true
  def call(%{message: %{guild_id: guild_id}} = command, _) do
    embed =
      guild_id
      |> LavaLink.now_playing()
      |> Track.to_embed(:now_playing)

    set_response(command, embed: embed)
  end
end
