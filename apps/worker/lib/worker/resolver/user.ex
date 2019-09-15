defmodule Worker.Resolver.User do
  alias Rpc.Cache
  alias Worker.Resolver.Member

  def resolve(query, guild \\ nil) do
    # Min length to avoid intepreting names like "1234" as ids
    case Regex.run(~r/^<@!?(\d{15,})>$|^(\d{15,})$/, query) do
      [_, "", id] ->
        id
        |> String.to_integer()
        |> Member.fetch_user(false)

      [_, id] ->
        id
        |> String.to_integer()
        |> Member.fetch_user(false)

      nil ->
        if guild do
          case Member.resolve(query, guild) do
            %{user: user_id} ->
              Cache.fetch!(User, user_id)

            nil ->
              nil
          end
        end
    end
  end
end
