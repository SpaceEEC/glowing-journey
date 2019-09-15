defmodule Worker.Command.Music.Loop do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: Template.loop_description()
  @impl true
  def usages(), do: Template.loop_usages()
  @impl true
  def examples(), do: Template.loop_examples()

  @impl true
  def triggers(), do: ["loop"]
  @impl true
  def required(),
    do: [
      MiddleWare.GuildOnly,
      {MiddleWare.Connected, :loop},
      {MiddleWare.DJ, &MiddleWare.OwnerOnly.owner?/1}
    ]

  @impl true
  def call(%{args: [], message: %{guild_id: guild_id}} = command, _) do
    content =
      if LavaLink.loop(guild_id) do
        Template.loop_enabled()
      else
        Template.loop_disabled()
      end

    set_response(command, content: content)
  end

  def call(%{args: [state | _], message: %{guild_id: guild_id}} = command, _) do
    state = String.downcase(state)

    state =
      cond do
        state in ["y", "yes", "enable", "true"] ->
          true

        state in ["n", "no", "disable", "false"] ->
          false

        true ->
          :error
      end

    content =
      if state == :error do
        Template.loop_invalid_state()
      else
        if LavaLink.loop(guild_id, state) do
          Template.loop_updated()
        else
          Template.loop_already()
        end
      end

    set_response(command, content: content)
  end
end
