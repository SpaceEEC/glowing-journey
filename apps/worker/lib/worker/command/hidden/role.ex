defmodule Worker.Command.Hidden.Role do
  use Worker.Command

  @impl true
  def description(), do: "Finds a role via name, mention, or id."
  @impl true
  def examples() do
    """
    Examples:
    - `role @role`
    - `role role`
    - `role 364782757697683456`
    """
  end

  @impl true
  def usages() do
    """
    Usage: `role <Name|Mention|ID>`
    """
  end

  @impl true
  def triggers(), do: ["role"]

  @impl true
  def required(), do: [Worker.MiddleWare.GuildOnly, Worker.MiddleWare.FetchGuild]

  alias Worker.Resolver.Role

  @impl true
  def call(%{args: [word | _]} = command, _) do
    role = Role.resolve(word, command)

    set_response(command,
      content: """
      Found
      ```elixir
      #{inspect(role, pretty: true, width: 0)}
      ```
      """
    )
  end
end
