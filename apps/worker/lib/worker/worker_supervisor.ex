defmodule Worker.WorkerSupervisor do
  use ConsumerSupervisor

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(arg) do
    ConsumerSupervisor.start_link(__MODULE__, arg, [])
  end

  def init(_arg) do
    Rpc.cache_alive?()
    |> startup()
  end

  defp startup(true) do
    children = [Worker]
    opts = [strategy: :one_for_one, subscribe_to: Rpc.Cache.producers()]

    ConsumerSupervisor.init(children, opts)
  end

  defp startup(false) do
    require Logger
    Logger.warn("#{Rpc.cache()} node is not alive, waiting 10 seconds and trying again")

    Process.sleep(10_000)

    Rpc.cache_alive?()
    |> startup()
  end
end
