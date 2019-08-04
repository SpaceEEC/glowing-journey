defmodule Worker.Command.Config.Locale do
  use Worker.Command

  alias Worker.Command.Config

  @impl true
  def description(), do: :LOC_LOCALE_DESCRIPTION
  @impl true
  def usages(), do: :LOC_LOCALE_USAGES
  @impl true
  def examples(), do: :LOC_LOCALE_EXAMPLES

  @impl true
  def triggers(), do: ["locale", "lang", "language"]
  @impl true
  def required(), do: [Worker.MiddleWare.GuildOnly]

  @impl true
  def call(%{args: []} = command, _) do
    Config.get(command, "locale", "")
  end

  def call(%{args: args} = command, _) do
    Config.set(command, "locale", Enum.join(args, " "))
  end
end
