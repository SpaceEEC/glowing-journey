defmodule Worker.Resolver.Channel do
  alias Rpc.Cache
  alias Simetric.Levenshtein

  def resolve(query, type \\ nil, guild)

  def resolve(query, type, %{assigns: %{guild: guild}}) do
    resolve(query, type, guild)
  end

  def resolve(query, type, %{channels: channels}) do
    case Regex.run(~r/^<#(\d{15,})>$|^(\d{15,})$/, query) do
      [_, "", id] ->
        id = String.to_integer(id)

        if MapSet.member?(channels, id) do
          case Cache.fetch(Channel, id) do
            {:ok, channel} -> channel
            :error -> nil
          end
        end

      [_, id] ->
        id = String.to_integer(id)

        if MapSet.member?(channels, id) do
          case Cache.fetch(Channel, id) do
            {:ok, channel} -> channel
            :error -> nil
          end
        end

      nil ->
        query = String.downcase(query)

        channels
        |> MapSet.to_list()
        |> Cache.get_channels()
        |> Enum.map(&{get_dist(&1, type, query), &1})
        |> Enum.min_by(&elem(&1, 0), fn -> nil end)
        |> case do
          nil ->
            nil

          {dist, _channel} when dist > 3 ->
            nil

          {_dist, channel} ->
            channel
        end
    end
  end

  def get_dist(%{name: name, type: channel_type}, wanted_type, query)
      when is_nil(wanted_type)
      when wanted_type == channel_type do
    name
    |> String.downcase()
    |> Levenshtein.compare(query)
  end

  # Long enough
  def get_dist(_, _, _), do: 123_456_789
end
