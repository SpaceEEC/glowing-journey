defmodule Rpc do
  @moduledoc false

  @cache :"cache@127.0.0.1"
  @gateway :"gateway@127.0.0.1"
  @rest :"rest@127.0.0.1"
  @lavalink :"lavalink@127.0.0.1"
  @worker :"worker@127.0.0.1"
  @no_node :nonode@nohost
  @single_node :"offline@127.0.0.1"

  def cache(), do: @cache
  def gateway(), do: @gateway
  def rest(), do: @rest
  def lavalink(), do: @lavalink
  def worker(), do: @worker

  defguard is_offline() when node() in [@no_node, @single_node]

  def cache_alive?(), do: is_offline() or Node.ping(@cache) == :pong
  def gateway_alive?(), do: is_offline() or Node.ping(@gateway) == :pong
  def rest_alive?(), do: is_offline() or Node.ping(@rest) == :pong
  def lavalink_alive?(), do: is_offline() or Node.ping(@lavalink) == :pong
  def worker_alive?(), do: is_offline() or Node.ping(@worker) == :pong

  defmacro __using__(type) when type in [:cache, :gateway, :rest, :lavalink, :worker] do
    quote location: :keep do
      require Rpc

      @local_node String.to_atom(Atom.to_string(unquote(type)) <> "@127.0.0.1")

      @doc """
        Whether the invoking node is the local node in the contex of the module.
      """
      defguard is_local() when Rpc.is_offline() or node() == @local_node

      @doc """
        Invokes this function with the given args in the correct node.

        Uses `:rpc.call/4` behind the scenes.
      """
      defmacro do_rpc(args) do
        quote do
          {mod, _arity} = __ENV__.function()

          Rpc.call(
            unquote(@local_node),
            __MODULE__,
            mod,
            unquote(args)
          )
        end
      end

      defmacro ensure_loaded(mod) do
        quote do
          mod = unquote(mod)
          {:module, ^mod} = Code.ensure_loaded(mod)

          mod
        end
      end
    end
  end

  alias Rpc.RpcError

  @doc """
    Calls a `node` executing a `fun` in a `mod` with the given ´args`.

    Internally uses `:rpc.call/4`.

    Raises when:
    * The called function raises
    * The target node is down
    * Another other rpc error occurs
  """
  @spec call(node(), module(), fun :: atom(), args :: list()) :: term() | no_return()
  def call(node, mod, fun, args)
      when is_atom(node) and is_atom(mod) and is_atom(fun) and is_list(args) do
    :rpc.call(node, mod, fun, args)
    |> case do
      {:badrpc, {:EXIT, {kind, stacktrace}}} ->
        exception = Exception.normalize(:error, kind, stacktrace)

        reraise RpcError, [exception, args], stacktrace

      {:badrpc, :nodedown} ->
        raise RpcError, ["The target node \"#{node}\" is down", args]

      {:badrpc, reason} ->
        raise RpcError, [
          """
          received an unexpected ":badrpc"
          #{inspect(reason)}
          target:
          #{node}
          """,
          args
        ]

      other ->
        other
    end
  end
end
