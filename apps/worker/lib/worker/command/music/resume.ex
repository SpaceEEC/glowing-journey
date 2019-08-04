defmodule Worker.Command.Music.Resume do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: :LOC_RESUME_DESCRIPTION
  @impl true
  def usages(), do: :LOC_RESUME_USAGES
  @impl true
  def examples(), do: :LOC_RESUME_EXAMPLES
  @impl true
  def triggers(), do: ["resume"]
  @impl true
  def required(),
    do: [
      MiddleWare.GuildOnly,
      {MiddleWare.Connected, :resume},
      {MiddleWare.DJ, &MiddleWare.OwnerOnly.owner?/1}
    ]

  @impl true
  def call(%{message: %{guild_id: guild_id}} = command, _) do
    content =
      if LavaLink.resume(guild_id) do
        :LOC_RESUME_RESUMED
      else
        :LOC_RESUME_ALREADY
      end

    set_response(command, content: content)
  end
end
