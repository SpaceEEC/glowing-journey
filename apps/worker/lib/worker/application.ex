defmodule Worker.Application do
  @moduledoc false

  use Application
  require Rpc

  def start(_, _) do
    Rpc.Sentry.install()

    if Rpc.is_offline() do
      Application.ensure_started(:gateway)
      Application.ensure_started(:cache)
    end

    Worker.Supervisor.start_link([])
  end
end
