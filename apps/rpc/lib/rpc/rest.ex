defmodule Rpc.Rest do
  use Rpc, :rest
  require Rpc

  use Crux.Rest

  def request(request) when is_local() do
    Rest.request(request)
  end

  def request(request) do
    do_rpc([request])
  end

  def request!(request) when is_local() do
    Rest.request!(request)
  end

  def request!(request) do
    do_rpc([request])
  end
end
