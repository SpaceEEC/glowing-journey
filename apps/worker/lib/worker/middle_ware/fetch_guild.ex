defmodule Worker.MiddleWare.FetchGuild do
  @moduledoc """
    Fetches the guild of the command and assigns it to `guild`.

    If the command originates from a dm, `nil` will be assigned.
  """

  alias Util.Locale.Template

  use Worker.MiddleWare

  alias Rpc.Sentry
  require Sentry

  # Already fetched, do nothing
  def call(%{assigns: %{guild: _}} = command, _opts) do
    command
  end

  def call(%{message: %{guild_id: nil}} = command, _opts) do
    Sentry.debug("DM; assigning nil", "middleware")

    assign(command, :guild, nil)
  end

  def call(%{message: %{guild_id: guild_id}} = command, _opts) do
    Cache.fetch(Guild, guild_id)
    |> case do
      {:ok, guild} ->
        Sentry.debug("Successfully fetched guild #{guild_id}", "middleware")

        assign(command, :guild, guild)

      :error ->
        Sentry.warn("Could not find a guild with the id #{guild_id} in the cache.", "middleware")

        command
        |> set_response(content: Template.fetchguild_uncached())
        |> halt()
    end
  end
end
