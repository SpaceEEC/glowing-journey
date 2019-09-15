defmodule Worker.Resolver.Member do
  alias Rpc.{Cache, Rest}
  alias Simetric.Levenshtein

  @max_dist 3

  def resolve(query, guild)

  def resolve(query, %{assigns: %{guild: guild}}) when not is_nil(guild) do
    resolve(query, guild)
  end

  def resolve(query, %{id: guild_id, members: members}) do
    # Min length to avoid intepreting names like "1234" as ids
    case Regex.run(~r/^<@!?(\d{15,})>$|^(\d{15,})$/, query) do
      [_, "", id] ->
        Map.get(members, String.to_integer(id))

      [_, id] ->
        user_id = String.to_integer(id)
        Map.get_lazy(members, user_id, fn -> fetch_member(guild_id, user_id) end)

      nil ->
        query = String.downcase(query)

        members
        |> Map.values()
        |> Enum.map(&{get_dist(&1, query), &1})
        |> Enum.min_by(&elem(&1, 0), fn -> nil end)
        |> case do
          nil ->
            nil

          {dist, _member} when dist > @max_dist ->
            nil

          {_dist, member} ->
            member
        end
    end
  end

  def get_dist(%{nickname: nickname, user: user_id}, query) when not is_nil(nickname) do
    nickname
    |> String.downcase()
    |> Levenshtein.compare(query)
    |> min(get_dist(%{user: user_id}, query))
  end

  def get_dist(%{user: user_id}, query) do
    case fetch_user(user_id) do
      nil ->
        @max_dist + 1

      user ->
        user
        |> Map.get(:username)
        |> String.downcase()
        |> Levenshtein.compare(query)
    end
  end

  def fetch_user(user_id, cache \\ true) do
    with :error <- Cache.fetch(User, user_id),
         {:ok, user} <- Rest.Raw.get_user(user_id) do
      if cache do
        Cache.insert(User, user)
      end

      user
      |> Crux.Structs.create(User)
    else
      :error ->
        nil

      {:ok, user} ->
        user
    end
  end

  def fetch_member(guild_id, user_id) do
    request = Crux.Rest.Functions.get_guild_member(guild_id, user_id)

    case Rest.request(request) do
      {:ok, %{"user" => user} = member} ->
        member = Map.put(member, "guild_id", guild_id)

        Cache.insert(:Member, member)
        Cache.insert(:User, user)

        Crux.Structs.create(member, Crux.Structs.Member)

      {:error, _error} ->
        nil
    end
  end
end
