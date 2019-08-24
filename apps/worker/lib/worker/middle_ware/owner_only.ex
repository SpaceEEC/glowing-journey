defmodule Worker.MiddleWare.OwnerOnly do
  @moduledoc """
    Ensures that the author of the message is registered as an owner of the bot.
  """

  use Worker.MiddleWare

  # Command.t()
  def owner?(%{message: message}), do: owner?(message)
  # Message.t()
  def owner?(%{author: user}), do: owner?(user)
  # Member.t()
  def owner?(%{user: user_id}), do: owner?(user_id)
  # User.t()
  def owner?(%{id: user_id}), do: owner?(user_id)

  # snowflake()
  def owner?(user_id) do
    user_id in Worker.Commands.get_owners()
  end

  def call(command, reply \\ true)

  def call(command, predicate) when is_function(predicate, 1) do
    if predicate.(command) do
      require Logger
      Logger.debug(fn -> "Predicate evaluated to true; bypasses." end)

      call(command)
    else
      command
    end
  end

  def call(command, reply) do
    if owner?(command) do
      command
    else
      if reply do
        command
        |> set_response(content: :LOC_OWNERONLY)
      else
        command
      end
      |> halt()
    end
  end
end
