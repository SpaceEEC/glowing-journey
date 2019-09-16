defmodule Cache.Application do
  @moduledoc false

  use Application
  require Logger
  require Rpc

  def start(_type, _args) do
    Rpc.Sentry.install()

    if Rpc.is_offline() do
      Application.ensure_started(:gateway)
    else
      Application.put_env(:sentry, :tags, %{node: node()})
    end

    Rpc.gateway_alive?()
    |> startup()
  end

  defp startup(true) do
    Logger.info("Starting cache application")

    gateway =
      if Rpc.is_offline() do
        Gateway
      else
        {Gateway, Rpc.gateway()}
      end

    base_opts = {
      %{
        gateway: gateway,
        cache_provider: Crux.Cache.Default,
        consumer: Cache.Consumer
      },
      name: Base
    }

    children = [
      # TODO: Once fixed, give this process a name
      {Crux.Cache.Default, []},
      {Crux.Base, base_opts}
    ]

    opts = [strategy: :one_for_one, name: Cache.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp startup(false) do
    Logger.warn("#{Rpc.gateway()} node is not alive, waiting 10 seconds and trying again")

    Process.sleep(10_000)

    Rpc.gateway_alive?()
    |> startup()
  end
end
