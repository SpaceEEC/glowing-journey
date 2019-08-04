defmodule Worker.Command.Misc.Help do
  use Worker.Command

  alias Worker.Commands

  @impl true
  def description(), do: :LOC_HELP_DESCRIPTION
  @impl true
  def usages(), do: :LOC_HELP_USAGES
  @impl true
  def examples(), do: :LOC_HELP_EXAMPLES

  @impl true
  def triggers(), do: ["help"]

  @impl true
  def call(%{args: []} = command, _) do
    groups =
      for {group, commands} when group != "Hidden" <- Commands.get_command_groups() do
        entries =
          for command <- commands do
            [name | _aliases] = command.triggers()
            {:LOC_HELP_OVERVIEW_ENTRY, name: name, description: command.description()}
          end

        {:LOC_HELP_OVERVIEW_GROUP, group: group, entries: entries}
      end

    content = {:LOC_HELP_OVERVIEW, groups: groups}

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
                {:LOC_HELP_NAME, name: name}

              [name | aliases] ->
                aliases = Enum.join(aliases, "``, ``")
                {:LOC_HELP_NAME_ALIASES, name: name, aliases: aliases}
            end

          description =
            if function_exported?(command, :description, 1) do
              command.description(:long)
            else
              command.description()
            end

          {:LOC_HELP_DETAILED,
           name: name,
           description: description,
           usages: command.usages(),
           examples: command.examples()}

        _ ->
          :LOC_HELP_UNKNOWN_COMMAND
      end

    set_response(command, content: response)
  end
end
