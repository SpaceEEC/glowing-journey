defmodule Worker.MiddleWare.GuildOnly do
  @moduledoc """
    Ensures the command is being ran in a guild.

    Options:
    * `(Command.t() -> boolean())`
      Predicate function to bypass this middle ware
  """
  use Worker.MiddleWare

  def call(command, predicate) when is_function(predicate, 1) do
    if predicate.(command) do
      require Logger
      Logger.debug(fn -> "Predicate evaluated to true; bypasses." end)

      command
    else
      call(command, [])
    end
  end

  def call(%{message: %{guild_id: nil}} = command, _opts) do
    command
    |> set_response(content: :GUILD_ONLY)
    |> halt()
  end

  def call(command, _opts), do: command
end
