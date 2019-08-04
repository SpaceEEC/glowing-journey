defmodule Worker do
  def start_link(event) do
    Task.start_link(__MODULE__, :handle_event, [event])
  end

  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      restart: :temporary
    }
  end

  def handle_event({:MESSAGE_CREATE, %{author: %{bot: false}} = message, shard_id}) do
    Worker.Commands.handle(message, shard_id)
  end

  def handle_event({:VOICE_SERVER_UPDATE, data, _shard_id}) do
    Rpc.LavaLink.forward(data)
  end

  def handle_event({:VOICE_STATE_UPDATE, {_, state}, _shard_id}) do
    state
    |> Map.from_struct()
    |> Rpc.LavaLink.forward()
  end

  def handle_event(_), do: nil
end
