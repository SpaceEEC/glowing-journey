defmodule Worker.Command.Hidden.User do
  use Worker.Command

  @impl true
  def description(), do: "Finds a user via name, mention, or id."
  @impl true
  def examples() do
    """
    Examples:
    - `user @user`
    - `user user`
    - `user 364782757697683456`
    """
  end

  @impl true
  def usages() do
    """
    Usage: `user <Name|Mention|ID>`
    """
  end

  @impl true
  def triggers(), do: ["user"]

  @impl true
  def required(), do: [Worker.MiddleWare.FetchGuild]

  alias Worker.Resolver.User

  @impl true
  def call(%{args: [word | _]} = command, _) do
    user = User.resolve(word, command)

    set_response(command,
      content: """
      Found
      ```elixir
      #{inspect(user, pretty: true, width: 0)}
      ```
      """
    )
  end
end
