defmodule Worker.Command.Music.Shuffle do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: Template.shuffle_description()
  @impl true
  def usages(), do: Template.shuffle_usages()
  @impl true
  def examples(), do: Template.shuffle_examples()
  @impl true
  def disabled(), do: Template.music_disabled()

  @impl true
  def triggers(), do: ["shuffle"]
  @impl true
  def required(),
    do: [
      MiddleWare.GuildOnly,
      {MiddleWare.Connected, :shuffle},
      {MiddleWare.DJ, &MiddleWare.OwnerOnly.owner?/1}
    ]

  @impl true
  def call(%{message: %{guild_id: guild_id}} = command, _) do
    :ok = LavaLink.shuffle(guild_id)

    set_response(command, content: Template.shuffle_shuffled())
  end
end
