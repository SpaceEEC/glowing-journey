defmodule Worker.Command.Music.Remove do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: Template.remove_description()
  @impl true
  def usages(), do: Template.remove_usages()
  @impl true
  def examples(), do: Template.remove_examples()
  @impl true
  def disabled(), do: Template.music_disabled()

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
    |> set_response(content: Template.generic_no_args())
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
    Template.remove_position_nan()
  end

  def remove(_position, :error, _guild_id) do
    Template.remove_count_nan()
  end

  def remove(position, _count, _guild_id)
      when position < 0 do
    Template.remove_position_negative()
  end

  def remove(_position, count, _guild_id)
      when count < 1 do
    Template.remove_count_smaller_one()
  end

  def remove(position, count, guild_id) do
    case LavaLink.remove(guild_id, position + 1, count) do
      nil ->
        Template.remove_position_out_of_bounds()

      tracks ->
        count = Enum.count(tracks)

        Template.remove_removed(count)
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
