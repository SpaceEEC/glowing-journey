defmodule Worker.MiddleWare.OwnerOnly do
  @moduledoc """
    Ensures that the author of the message is registered as an owner of the bot.
  """

  alias Util.Locale.Template

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
      require Rpc.Sentry
      Rpc.Sentry.debug("Predicate evaluated to true; bypasses.", "middleware")

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
        |> set_response(content: Template.owneronly())
      else
        command
      end
      |> halt()
    end
  end
end
