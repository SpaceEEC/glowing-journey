defmodule Worker.Command.Config.Prefix do
  use Worker.Command

  alias Worker.Command.Config

  @impl true
  def description(), do: Template.prefix_description()
  @impl true
  def usages(), do: Template.prefix_usages()
  @impl true
  def examples(), do: Template.prefix_examples()

  @impl true
  def triggers(), do: ["prefix"]
  @impl true
  def required() do
    [
      MiddleWare.GuildOnly,
      {MiddleWare.HasPermissions,
       {
         :manage_guild,
         nil,
         :member,
         fn
           %{args: []} -> true
           _ -> false
         end
       }}
    ]
  end

  @impl true
  def call(%{args: []} = command, _) do
    Config.get(command, "prefix", "")
  end

  def call(%{args: args} = command, _) do
    Config.set(command, "prefix", Enum.join(args, " "))
  end
end
