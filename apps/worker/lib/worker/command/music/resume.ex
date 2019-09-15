defmodule Worker.Command.Music.Resume do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: Template.resume_description()
  @impl true
  def usages(), do: Template.resume_usages()
  @impl true
  def examples(), do: Template.resume_examples()
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
        Template.resume_resumed()
      else
        Template.resume_already()
      end

    set_response(command, content: content)
  end
end
