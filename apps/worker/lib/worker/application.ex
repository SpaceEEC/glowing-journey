defmodule Worker.Application do
  @moduledoc false

  use Application

  def start(_, _) do
    Rpc.Sentry.install()

    if Rpc.local?() do
      Application.ensure_started(:gateway)
      Application.ensure_started(:cache)
    end

    Worker.Supervisor.start_link([])
  end
end
