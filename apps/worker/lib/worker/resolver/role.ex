defmodule Worker.Resolver.Role do
  alias Simetric.Levenshtein

  def resolve(query, allow_everyone \\ false, guild)

  def resolve(query, allow_everyone, %{assigns: %{guild: guild}}) when not is_nil(guild) do
    resolve(query, allow_everyone, guild)
  end

  def resolve(query, allow_everyone, %{id: guild_id, roles: roles}) do
    case Regex.run(~r/^<@&(\d{15,})>$|^(\d{15,})$/, query) do
      [_, "", id] ->
        Map.get(roles, String.to_integer(id))

      [_, id] ->
        Map.get(roles, String.to_integer(id))

      nil ->
        query = String.downcase(query)

        roles =
          if allow_everyone do
            roles
          else
            Map.delete(roles, guild_id)
          end

        roles
        |> Map.values()
        |> Enum.map(&{get_dist(&1, query), &1})
        |> Enum.min_by(&elem(&1, 0), fn -> nil end)
        |> case do
          nil ->
            nil

          {dist, _role} when dist > 3 ->
            nil

          {_dist, role} ->
            role
        end
    end
  end

  def get_dist(%{name: name}, query) do
    name
    |> String.downcase()
    |> Levenshtein.compare(query)
  end
end
