defmodule Rpc.Cache do
  use Rpc, :cache
  require Rpc

  @types [Channel, Emoji, Guild, Presence, User]

  # Exceptions, those only exist on user
  def me() when is_local() do
    Crux.Cache.User.me()
  end

  def me(), do: do_rpc()

  def me!() when is_local() do
    Crux.Cache.User.me!()
  end

  def me!(), do: do_rpc()

  # Helper
  def get_channels(ids) when is_local() and is_list(ids) do
    Enum.flat_map(ids, fn id ->
      case Crux.Cache.Channel.fetch(id) do
        {:ok, channel} -> [channel]
        :error -> []
      end
    end)
  end

  def get_channels(ids) when is_list(ids) do
    do_rpc()
  end

  # General cache api, all caches implement them
  def delete(type, id) when is_local() and type in @types do
    mod = Module.safe_concat(Crux.Cache, type)
    apply(mod, :delete, [id])
  end

  def delete(type, id) when type in @types do
    do_rpc()
  end

  def fetch(type, id) when is_local() and type in @types do
    mod = Module.safe_concat(Crux.Cache, type)
    apply(mod, :fetch, [id])
  end

  def fetch(type, id) when type in @types do
    do_rpc()
  end

  def fetch!(type, id) when is_local() and type in @types do
    mod = Module.safe_concat(Crux.Cache, type)
    apply(mod, :fetch!, [id])
  end

  def fetch!(type, id) when type in @types do
    do_rpc()
  end

  def insert(type, data) when is_local() and type in @types do
    mod = Module.safe_concat(Crux.Cache, type)
    apply(mod, :insert, [data])
  end

  def insert(type, data) when type in @types do
    do_rpc()
  end

  def update(type, data) when is_local() and type in @types do
    mod = Module.safe_concat(Crux.Cache, type)
    apply(mod, :update, [data])
  end

  def update(type, data) when type in @types do
    do_rpc()
  end

  # Not strictly cache, but in the same node

  def producers() when is_local() do
    Base |> Crux.Base.producers() |> Map.values()
  end

  def producers(), do: do_rpc()
end
