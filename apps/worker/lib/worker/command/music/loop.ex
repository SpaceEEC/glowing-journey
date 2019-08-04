defmodule Worker.Command.Music.Loop do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: :LOC_LOOP_DESCRIPTION
  @impl true
  def usages(), do: :LOC_LOOP_USAGES
  @impl true
  def examples(), do: :LOC_LOOP_EXAMPLES

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
        :LOC_LOOP_ENABLED
      else
        :LOC_LOOP_DISABLED
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
        :LOC_LOOP_INVALID_STATE
      else
        if LavaLink.loop(guild_id, state) do
          :LOC_LOOP_UPDATED
        else
          :LOC_LOOP_ALREADY
        end
      end

    set_response(command, content: content)
  end
end
