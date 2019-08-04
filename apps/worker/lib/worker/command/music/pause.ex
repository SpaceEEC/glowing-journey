defmodule Worker.Command.Music.Pause do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: :LOC_PAUSE_DESCRIPTION
  @impl true
  def usages(), do: :LOC_PAUSE_USAGES
  @impl true
  def examples(), do: :LOC_PAUSE_EXAMPLES
  @impl true
  def triggers(), do: ["pause"]
  @impl true
  def required(),
    do: [
      MiddleWare.GuildOnly,
      {MiddleWare.Connected, :pause},
      {MiddleWare.DJ, &MiddleWare.OwnerOnly.owner?/1}
    ]

  @impl true
  def call(%{message: %{guild_id: guild_id}} = command, _) do
    content =
      if LavaLink.pause(guild_id) do
        :LOC_PAUSE_PAUSED
      else
        :LOC_PAUSE_ALREADY
      end

    set_response(command, content: content)
  end
end
