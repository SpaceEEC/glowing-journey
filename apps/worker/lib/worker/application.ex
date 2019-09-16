defmodule Worker.Application do
  @moduledoc false

  use Application
  require Rpc
  require Logger

  def start(_, _) do
    Rpc.Sentry.install()

    if Rpc.is_offline() do
      Application.ensure_started(:gateway)
      Application.ensure_started(:cache)
    else
      Application.put_env(:sentry, :tags, %{node: node()})
    end

    Rpc.cache_alive?()
    |> startup()
  end

  defp startup(true) do
    Logger.info("Starting worker application")

    Worker.Supervisor.start_link([])
  end

  defp startup(false) do
    Logger.warn("#{Rpc.cache()} node is not alive, waiting 10 seconds and trying again")

    Process.sleep(10_000)

    Rpc.cache_alive?()
    |> startup()
  end
end
