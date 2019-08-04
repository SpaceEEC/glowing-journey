defmodule Rpc.Rest do
  use Rpc, :rest
  require Rpc

  use Crux.Rest

  def request(_name, request) when is_local() do
    super(Rest, request)
  end

  def request(name, request) do
    do_rpc()
  end

  def request!(_name, request) when is_local() do
    super(Rest, request)
  end

  def request!(name, request) do
    do_rpc()
  end
end
