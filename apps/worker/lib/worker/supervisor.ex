defmodule Worker.Supervisor do
  use ConsumerSupervisor

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(arg) do
    ConsumerSupervisor.start_link(__MODULE__, arg, [])
  end

  def init(_arg) do
    children = [Worker]
    opts = [strategy: :one_for_one, subscribe_to: Rpc.Cache.producers()]

    ConsumerSupervisor.init(children, opts)
  end
end
