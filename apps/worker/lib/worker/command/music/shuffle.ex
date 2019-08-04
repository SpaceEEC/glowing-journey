defmodule Worker.Command.Music.Shuffle do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: :LOC_SHUFFLE_DESCRIPTION
  @impl true
  def usages(), do: :LOC_SHUFFLE_USAGES
  @impl true
  def examples(), do: :LOC_SHUFFLE_EXAMPLES
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

    set_response(command, content: :LOC_SHUFFLE_SHUFFLED)
  end
end
