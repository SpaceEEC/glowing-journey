defmodule Worker.Command.Music.Volume do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: :LOC_VOLUME_DESCRIPTION
  @impl true
  def usages(), do: :LOC_VOLUME_USAGES
  @impl true
  def examples(), do: :LOC_VOLUME_EXAMPLES

  @impl true
  def required(), do: [MiddleWare.GuildOnly, {MiddleWare.Connected, :volume}]
  @impl true
  def triggers(), do: ["volume"]

  @impl true
  def call(%{args: [], message: %{guild_id: guild_id}} = command, _) do
    volume = LavaLink.volume(guild_id)

    set_response(command, content: {:LOC_VOLUME_CURRENT, volume: to_string(volume)})
  end

  def call(%{args: [volume | _], message: %{guild_id: guild_id}} = command, _) do
    content =
      case Integer.parse(volume) do
        {volume, ""}
        when volume in 0..1000 ->
          :ok = LavaLink.volume(guild_id, volume)

          :LOC_VOLUME_SET

        {_volume, ""} ->
          :LOC_VOLUME_OUT_OF_BOUNDS

        _ ->
          :LOC_VOLUME_NAN
      end

    set_response(command, content: content)
  end
end
