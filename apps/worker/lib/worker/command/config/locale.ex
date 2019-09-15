defmodule Worker.Command.Config.Locale do
  use Worker.Command

  alias Worker.Command.Config

  @impl true
  def description(), do: Template.locale_description()
  @impl true
  def usages(), do: Template.locale_usages()
  @impl true
  def examples(), do: Template.locale_examples()

  @impl true
  def triggers(), do: ["locale", "lang", "language"]
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
    Config.get(command, "locale", "")
  end

  def call(%{args: args} = command, _) do
    Config.set(command, "locale", Enum.join(args, " "))
  end
end
