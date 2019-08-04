defmodule Rpc do
  @moduledoc false

  @cache :"cache@127.0.0.1"
  @gateway :"gateway@127.0.0.1"
  @rest :"rest@127.0.0.1"
  @lavalink :"lavalink@127.0.0.1"
  @worker :"worker@127.0.0.1"
  @no_node :nonode@nohost

  def cache(), do: @cache
  def gateway(), do: @gateway
  def rest(), do: @rest
  def lavalink(), do: @lavalink
  def worker(), do: @worker

  def cache_alive?(), do: Node.ping(@cache) == :pong
  def gateway_alive?(), do: Node.ping(@gateway) == :pong
  def rest_alive?(), do: Node.ping(@rest) == :pong
  def lavalink_alive?(), do: Node.ping(@lavalink) == :pong
  def worker_alive?(), do: Node.ping(@worker) == :pong

  def local?(), do: node() == @no_node

  defmacro __using__(type) when type in [:cache, :gateway, :rest, :lavalink, :worker] do
    quote location: :keep do
      @local_node String.to_atom(Atom.to_string(unquote(type)) <> "@127.0.0.1")

      @doc """
        Whether the invoking node is the local node in the contex of the module.
      """
      defguard is_local() when node() in [unquote(@no_node), @local_node]

      @doc """
        Invokes this function with the given args in the correct node.

        Uses `:rpc.call/4` behind the scenes.
      """
      defmacro do_rpc() do
        quote do
          {mod, _arity} = __ENV__.function()

          Rpc.call(
            unquote(@local_node),
            __MODULE__,
            mod,
            unquote(
              __CALLER__
              |> Macro.Env.vars()
              |> Enum.map(&(&1 |> elem(0) |> Macro.var(nil)))
            )
          )
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
          received an unexpected ":badrcp"
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
