defmodule Worker.Command.Music.NowPlaying do
  use Worker.Command

  alias Rpc.LavaLink
  alias Rpc.LavaLink.Track

  @impl true
  def description(), do: :LOC_NOWPLAYING_DESCRIPTION
  @impl true
  def usages(), do: :LOC_NOWPLAYING_USAGES
  @impl true
  def examples(), do: :LOC_NOWPLAYING_EXAMPLES

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
