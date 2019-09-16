defmodule Worker.Command.Misc.Ping do
  use Worker.Command

  alias Crux.Structs.Snowflake
  alias Util.Locale

  @impl true
  def description(), do: Template.ping_description()
  @impl true
  def usages(), do: Template.ping_usages()
  @impl true
  def examples(), do: Template.ping_examples()

  @impl true
  def triggers(), do: ["ping"]

  @impl true
  def call(%{message: message} = command, _) do
    locale = Locale.fetch!(message)

    response = Locale.localize_response([content: Template.ping_pong()], locale)
    ping_message = Rest.create_message!(message, response)

    ping_time =
      Snowflake.deconstruct(ping_message.id).timestamp -
        Snowflake.deconstruct(message.id).timestamp

    response =
      Locale.localize_response(
        [content: Template.ping_time(ping_time)],
        locale
      )

    Rest.edit_message!(ping_message, response)

    command
  end
end
