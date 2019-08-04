defmodule Worker.Command.Config.Prefix do
  use Worker.Command

  alias Worker.Command.Config

  @impl true
  def description(), do: :LOC_PREFIX_DESCRIPTION
  @impl true
  def usages(), do: :LOC_PREFIX_USAGES
  @impl true
  def examples(), do: :LOC_PREFIX_EXAMPLES

  @impl true
  def triggers(), do: ["prefix"]
  @impl true
  def required(), do: [Worker.MiddleWare.GuildOnly]

  @impl true
  def call(%{args: []} = command, _) do
    Config.get(command, "prefix", "")
  end

  def call(%{args: args} = command, _) do
    Config.set(command, "prefix", Enum.join(args, " "))
  end
end
