defmodule Cache.Consumer do
  @moduledoc """
    Handles consuming and processing of events received from the gateway.
    To consume those processed events subscribe with a consumer to a producer.
    You can fetch said producers via `Crux.Base.producers/1`
  """

  @behaviour GenStage
  use GenStage

  alias Crux.Gateway.Connection.Producer, as: GatewayProducer

  alias Crux.Base.{Processor, Producer}

  @doc false
  @spec start_link(term()) :: GenServer.on_start()
  def start_link(arg) do
    GenStage.start_link(__MODULE__, arg)
  end

  @doc false
  @impl true
  def init(%{shard_id: shard_id, gateway: gateway, cache_provider: cache_provider, base: base}) do
    require Logger
    Logger.info("Starting cache consumer for shard #{shard_id}.")

    pid =
      gateway
      |> GatewayProducer.producers()
      |> Map.fetch!(shard_id)

    {:consumer, {base, cache_provider}, subscribe_to: [pid]}
  end

  @doc false
  @impl true
  def handle_events(events, _from, {base, cache_provider} = state) do
    for {type, data, shard_id} <- events,
        value <- type |> Processor.process_event(data, shard_id, cache_provider) |> List.wrap(),
        value != nil do
      Producer.dispatch({type, value, shard_id, base})
    end

    {:noreply, [], state}
  end

  @impl true
  def handle_cancel({:down, :noconnection}, _, state) do
    require Logger
    Logger.warn("No connection to gateway producer, waiting 10 seconds...")

    Process.sleep(10_000)

    {:noreply, [], state}
  end
end
