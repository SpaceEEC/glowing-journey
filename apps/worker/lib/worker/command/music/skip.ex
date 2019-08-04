defmodule Worker.Command.Music.Skip do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: :LOC_SKIP_DESCRIPTION
  @impl true
  def usages(), do: :LOC_SKIP_USAGES
  @impl true
  def examples(), do: :LOC_SKIP_EXAMPLES

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
          :LOC_SKIP_LESS_THAN_ONE

        :error ->
          :LOC_SKIP_NAN
      end

    set_response(command, content: response)
  end

  def skip(count, guild_id) do
    count =
      guild_id
      |> LavaLink.skip(count)
      |> Enum.count()

    {:LOC_SKIP_SKIPPED, count: to_string(count)}
  end
end
