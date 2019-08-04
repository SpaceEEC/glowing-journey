defmodule Worker.Command.Hidden.Channel do
  use Worker.Command

  @impl true
  def description(), do: "Finds a channel via name, mention, or id."
  @impl true
  def examples() do
    """
    Examples:
    - `channel #name`
    - `channel name`
    - `channel 364782757697683456`
    """
  end

  @impl true
  def usages() do
    """
    Usage: `channel <Name|Mention|ID>`
    """
  end

  @impl true
  def triggers(), do: ["channel"]

  @impl true
  def required(), do: [Worker.MiddleWare.GuildOnly, Worker.MiddleWare.FetchGuild]

  alias Worker.Resolver.Channel

  @impl true
  def call(%{args: [word | _]} = command, _) do
    channel = Channel.resolve(word, command)

    set_response(command,
      content: """
      Found
      ```elixir
      #{inspect(channel, pretty: true, width: 0)}
      ```
      """
    )
  end
end
