defmodule Gateway.Application do
  @moduledoc false

  use Application
  require Rpc
  require Logger

  @name Gateway
  def name(), do: @name

  def start(_type, _args) do
    Rpc.Sentry.install()

    if Rpc.is_offline() do
      Application.ensure_started(:rest)
    else
      Application.put_env(:sentry, :tags, %{node: node()})
    end
    Rpc.rest_alive?()
    |> startup()
  end

  defp startup(true) do
    Logger.info("Starting gateway application")

    %{"shards" => shard_count, "url" => url} = Rpc.Rest.gateway_bot!()

    gateway_opts = %{
      token: Application.fetch_env!(:gateway, :token),
      url: url,
      shard_count: shard_count
    }

    gen_opts = [name: @name]

    children = [
      {Crux.Gateway, {gateway_opts, gen_opts}}
    ]

    opts = [strategy: :one_for_one, name: Gateway.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp startup(false) do
    Logger.warn("#{Rpc.rest()} node is not alive, waiting 10 seconds and trying again")

    Process.sleep(10_000)

    Rpc.rest_alive?()
    |> startup()
  end
end
