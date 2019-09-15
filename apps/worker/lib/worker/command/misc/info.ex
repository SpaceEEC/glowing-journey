defmodule Worker.Command.Misc.Info do
  use Worker.Command

  @impl true
  def description(), do: Template.info_description()

  @impl true
  def usages(), do: Template.info_usages()

  @impl true
  def examples(), do: Template.info_examples()

  @impl true
  def triggers(), do: ["info"]

  @impl true
  def call(command, _) do
    set_response(command, content: "N/A")
  end
end
