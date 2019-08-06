defmodule Worker.Command.Misc.Ping do
  use Worker.Command

  alias Util.Locale

  @impl true
  def description(), do: :LOC_PING_DESCRIPTION
  @impl true
  def usages(), do: :LOC_PING_USAGES
  @impl true
  def examples(), do: :LOC_PING_EXAMPLES

  @impl true
  def triggers(), do: ["ping"]

  @impl true
  def call(%{message: message} = command, _) do
    locale = Locale.fetch!(message)

    response = Locale.localize_response([content: :LOC_PING_PONG], locale)
    ping_message = Rest.create_message!(message, response)

    ping_time = to_timestamp(ping_message) - to_timestamp(message)

    response =
      Locale.localize_response(
        [content: {:LOC_PING_TIME, ping: to_string(ping_time)}],
        locale
      )

    Rest.edit_message!(ping_message, response)

    command
  end

  # TODO: remove if available elsewhere
  defp to_timestamp(%{id: id}), do: to_timestamp(id)

  defp to_timestamp(id) when is_integer(id) do
    use Bitwise

    id >>> 22
  end
end
