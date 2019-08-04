defmodule Cache.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Rpc.Sentry.install()

    if Rpc.local?(), do: Application.ensure_started(:gateway)

    base_opts = {
      # TODO: Make this work cross node
      %{gateway: Gateway, cache_provider: Crux.Cache.Default},
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
end
