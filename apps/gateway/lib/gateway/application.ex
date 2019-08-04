defmodule Gateway.Application do
  @moduledoc false

  use Application

  @name Gateway
  def name(), do: @name

  def start(_type, _args) do
    Rpc.Sentry.install()

    if Rpc.local?(), do: Application.ensure_started(:rest)

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
end
