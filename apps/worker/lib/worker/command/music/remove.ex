defmodule Worker.Command.Music.Remove do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: :LOC_REMOVE_DESCRIPTION
  @impl true
  def usages(), do: :LOC_REMOVE_USAGES
  @impl true
  def examples(), do: :LOC_REMOVE_EXAMPLES

  @impl true
  def triggers(), do: ["remove"]
  @impl true
  def required(),
    do: [
      MiddleWare.GuildOnly,
      {MiddleWare.Connected, :remove},
      {MiddleWare.DJ, &MiddleWare.OwnerOnly.owner?/1}
    ]

  @impl true
  def call(%{args: []} = command, _) do
    command
    |> set_response(content: :LOC_GENERIC_NO_ARGS)
  end

  def call(%{args: args, message: %{guild_id: guild_id}} = command, _) do
    [position, count] =
      case args do
        [position] ->
          [to_integer(position), 1]

        [position, count | _] ->
          [to_integer(position), to_integer(count)]
      end

    content = remove(position, count, guild_id)

    set_response(command, content: content)
  end

  def remove(:error, _count, _guild_id) do
    :LOC_REMOVE_POSITION_NAN
  end

  def remove(_position, :error, _guild_id) do
    :LOC_REMOVE_COUNT_NAN
  end

  def remove(position, _count, _guild_id)
      when position < 0 do
    :LOC_REMOVE_POSITION_NEGATIVE
  end

  def remove(_position, count, _guild_id)
      when count < 1 do
    :LOC_REMOVE_COUNT_SMALLER_ONE
  end

  def remove(position, count, guild_id) do
    case LavaLink.remove(guild_id, position + 1, count) do
      nil ->
        :LOC_REMOVE_POSITION_OUT_OF_BOUNDS

      tracks ->
        count = Enum.count(tracks)

        {:LOC_REMOVE_REMOVED, count: to_string(count)}
    end
  end

  defp to_integer(value) do
    case Integer.parse(value) do
      {count, ""} ->
        count

      :error ->
        :error
    end
  end
end
