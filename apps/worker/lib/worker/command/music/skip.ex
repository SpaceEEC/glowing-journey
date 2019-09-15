defmodule Worker.Command.Music.Skip do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: Template.skip_description()
  @impl true
  def usages(), do: Template.skip_usages()
  @impl true
  def examples(), do: Template.skip_examples()

  @impl true
  def triggers(), do: ["skip"]

  @impl true
  def required(),
    do: [
      MiddleWare.GuildOnly,
      {MiddleWare.Connected, :skip},
      {MiddleWare.DJ, &MiddleWare.OwnerOnly.owner?/1}
    ]

  @impl true
  def call(%{args: [], message: %{guild_id: guild_id}} = command, _) do
    set_response(command, content: skip(1, guild_id))
  end

  def call(
        %{
          args: [count | _],
          message: %{guild_id: guild_id}
        } = command,
        _
      ) do
    response =
      case Integer.parse(count) do
        {count, ""} when count > 0 ->
          skip(count, guild_id)

        {_count, ""} ->
          Template.skip_less_than_one()

        :error ->
          Template.skip_nan()
      end

    set_response(command, content: response)
  end

  def skip(count, guild_id) do
    count =
      guild_id
      |> LavaLink.skip(count)
      |> Enum.count()

    Template.skip_skipped(count)
  end
end
