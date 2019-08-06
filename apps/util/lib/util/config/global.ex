defmodule Util.Config.Global do
  alias Util.Config.Etcd

  @blacklist_prefix "global:blacklist:"

  @spec blacklisted?(
          user_or_guild_or_id_or_nil :: %{id: Crux.Rest.snowflake()} | Crux.Rest.snowflake() | nil
        ) :: boolean()
  def blacklisted?(%{id: id}), do: blacklisted?(id)

  def blacklisted?(nil), do: false

  def blacklisted?(id) do
    Etcd.get(@blacklist_prefix <> to_string(id), nil) != nil
  end

  @spec get_blacklisted :: [Crux.Rest.snowflake()]
  def get_blacklisted() do
    Etcd.range_prefix(@blacklist_prefix)
    |> Enum.map(fn {@blacklist_prefix <> k, _v} -> String.to_integer(k) end)
  end

  @spec blacklist(
          user_or_guild_or_id :: term(),
          state :: boolean()
        ) :: term()

  def blacklist(%{id: id}, state), do: blacklist(id, state)

  def blacklist(id, true) do
    Etcd.put(@blacklist_prefix <> id, "true")
  end

  def blacklist(id, false) do
    Etcd.delete(@blacklist_prefix <> id)
  end
end
