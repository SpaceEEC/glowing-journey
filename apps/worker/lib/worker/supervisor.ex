defmodule Worker.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, [])
  end

  def init(_arg) do
    require Logger
    Logger.debug("SUPERVISOR STARTING")

    Supervisor.init([Worker.WorkerSupervisor], strategy: :one_for_one)
  end
end
