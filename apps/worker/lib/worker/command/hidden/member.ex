defmodule Worker.Command.Hidden.Member do
  use Worker.Command

  @impl true
  def description(), do: "Finds a member via name, mention, or id."
  @impl true
  def examples() do
    """
    Examples:
    - `member @member`
    - `member member`
    - `member 364782757697683456`
    """
  end

  @impl true
  def usages() do
    """
    Usage: `member <Name|Mention|ID>`
    """
  end

  @impl true
  def triggers(), do: ["member"]

  @impl true
  def required(), do: [Worker.MiddleWare.GuildOnly, Worker.MiddleWare.FetchGuild]

  alias Worker.Resolver.Member

  @impl true
  def call(%{args: [word | _]} = command, _) do
    member = Member.resolve(word, command)

    set_response(command,
      content: """
      Found
      ```elixir
      #{inspect(member, pretty: true, width: 0)}
      ```
      """
    )
  end
end
