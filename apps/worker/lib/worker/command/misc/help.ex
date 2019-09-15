defmodule Worker.Command.Misc.Help do
  use Worker.Command

  alias Worker.Commands

  @impl true
  def description(), do: Template.help_description()
  @impl true
  def usages(), do: Template.help_usages()
  @impl true
  def examples(), do: Template.help_examples()

  @impl true
  def triggers(), do: ["help"]

  @impl true
  def call(%{args: []} = command, _) do
    groups =
      for {group, commands} when group != "Hidden" <- Commands.get_command_groups() do
        entries =
          for command <- commands do
            [name | _aliases] = command.triggers()
            Template.help_overview_entry(name, command.description())
          end

        Template.help_overview_group(group, entries)
      end

    content = Template.help_overview(groups)

    set_response(command, content: content)
  end

  def call(%{args: [command_name | _]} = command, _) do
    command_name = String.downcase(command_name)

    response =
      case Commands.get_command_map() do
        %{^command_name => command} ->
          name =
            case command.triggers() do
              [name] ->
                Template.help_name(name)

              [name | aliases] ->
                aliases = Enum.join(aliases, "``, ``")
                Template.help_name_aliases(name, aliases)
            end

          description =
            if function_exported?(command, :description, 1) do
              command.description(:long)
            else
              command.description()
            end

          Template.help_detailed(
            name,
            description,
            command.usages(),
            command.examples()
          )

        _ ->
          Template.help_unknown_command()
      end

    set_response(command, content: response)
  end
end
