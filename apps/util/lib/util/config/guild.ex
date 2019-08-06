defmodule Util.Config.Guild do
  alias Util.Config.Etcd

  @string_keys ~w(join_message leave_message)
  @role_keys ~w(dj_role)
  @channel_keys ~w(join_channel leave_channel voice_log_channel dj_channel)
  @keys @string_keys ++ @channel_keys ++ @role_keys ++ ~w(prefix locale)

  def get_keys(), do: @keys
  def string_keys(), do: @string_keys
  def role_keys(), do: @role_keys
  def channel_keys(), do: @channel_keys

  @guild_prefix "guild"

  for key <- @keys do
    def unquote(:"put_#{key}")(guild, value) do
      put(unquote(key), guild, value)
    end

    def unquote(:"get_#{key}")(guild, default \\ nil) do
      get(unquote(key), guild, default)
    end

    def unquote(:"delete_#{key}")(guild) do
      delete(unquote(key), guild)
    end
  end

  def get_all(guild) do
    id = resolve_guild_id(guild)
    prefix = "#{@guild_prefix}:#{id}:"
    prefix_size = byte_size(prefix)

    Etcd.range_prefix(prefix)
    |> Map.new(fn {<<_::binary-size(prefix_size), k::binary>>, v} ->
      {k, v}
    end)
  end

  defp resolve_guild_id(%{id: id}), do: id
  defp resolve_guild_id(id) when is_binary(id) or is_integer(id), do: id

  defp put(key, guild, value)
       when key in @keys and is_binary(value) do
    id = resolve_guild_id(guild)

    Etcd.put("#{@guild_prefix}:#{id}:#{key}", value)
  end

  defp get(key, guild, default)
       when key in @keys do
    id = resolve_guild_id(guild)

    value = Etcd.get("#{@guild_prefix}:#{id}:#{key}", default)

    if value != nil and (key in @channel_keys or key in @role_keys) do
      String.to_integer(value)
    else
      value
    end
  end

  defp delete(key, guild)
       when key in @keys do
    id = resolve_guild_id(guild)

    Etcd.delete("#{@guild_prefix}:#{id}:#{key}")
  end
end
