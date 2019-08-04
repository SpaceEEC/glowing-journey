defmodule Worker.Command.Misc.Info do
  use Worker.Command

  @impl true
  def description(), do: :LOC_INFO_DESCRIPTION
  @impl true
  def usages(), do: :LOC_INFO_USAGES
  @impl true
  def examples(), do: :LOC_INFO_EXAMPLES

  @impl true
  def triggers(), do: ["info"]

  @impl true
  def call(command, _) do
    set_response(command, content: "N/A")
  end
end
