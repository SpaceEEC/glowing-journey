defmodule Rpc.Rest.Raw do
  use Crux.Rest, transform: false

  def request(request) do
    request
    |> Map.put(:transform, nil)
    |> Rpc.Rest.request()
  end

  def request!(request) do
    request
    |> Map.put(:transform, nil)
    |> Rpc.Rest.request!()
  end
end
