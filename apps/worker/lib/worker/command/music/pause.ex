defmodule Worker.Command.Music.Pause do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: Template.pause_description()
  @impl true
  def usages(), do: Template.pause_usages()
  @impl true
  def examples(), do: Template.pause_examples()
  @impl true
  def disabled(), do: Template.music_disabled()

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
        Template.pause_paused()
      else
        Template.pause_already()
      end

    set_response(command, content: content)
  end
end
