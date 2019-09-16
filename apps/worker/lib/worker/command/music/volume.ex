defmodule Worker.Command.Music.Volume do
  use Worker.Command

  alias Util.Config.Guild
  alias Rpc.LavaLink

  @impl true
  def description(), do: Template.volume_description()
  @impl true
  def usages(), do: Template.volume_usages()
  @impl true
  def examples(), do: Template.volume_examples()

  @impl true
  def required(), do: [MiddleWare.GuildOnly, {MiddleWare.Connected, :volume}]
  @impl true
  def triggers(), do: ["volume"]

  @impl true
  def call(%{args: [], message: %{guild_id: guild_id}} = command, _) do
    volume = LavaLink.volume(guild_id)

    set_response(command, content: Template.volume_current(volume))
  end

  def call(%{args: [volume | _], message: %{guild_id: guild_id}} = command, _) do
    content =
      case Integer.parse(volume) do
        {volume, ""}
        when volume in 0..1000 ->
          :ok = LavaLink.volume(guild_id, volume)
          :ok = Guild.put_volume(guild_id, to_string(volume))

          Template.volume_set(volume)

        {_volume, ""} ->
          Template.volume_out_of_bounds()

        _ ->
          Template.volume_nan()
      end

    set_response(command, content: content)
  end
end
