defmodule Worker.Command.Misc.Ping do
  use Worker.Command

  @impl true
  def description(), do: :LOC_PING_DESCRIPTION
  @impl true
  def usages(), do: :LOC_PING_USAGES
  @impl true
  def examples(), do: :LOC_PING_EXAMPLES

  @impl true
  def triggers(), do: ["ping"]

  @impl true
  def call(command, _) do
    set_response(command, content: :LOC_PING_PONG)
  end
end
