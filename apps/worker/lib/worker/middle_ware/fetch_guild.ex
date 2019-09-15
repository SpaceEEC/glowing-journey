defmodule Worker.MiddleWare.FetchGuild do
  @moduledoc """
    Fetches the guild of the command and assigns it to `guild`.

    If the command originates from a dm, `nil` will be assigned.
  """

  alias Util.Locale.Template

  use Worker.MiddleWare

  require Logger

  # Already fetched, do nothing
  def call(%{assigns: %{guild: _}} = command, _opts) do
    command
  end

  def call(%{message: %{guild_id: nil}} = command, _opts) do
    Logger.debug(fn -> "DM; assigning nil" end)

    assign(command, :guild, nil)
  end

  def call(%{message: %{guild_id: guild_id}} = command, _opts) do
    Cache.fetch(Guild, guild_id)
    |> case do
      {:ok, guild} ->
        Logger.debug(fn -> "Successfully fetched guild #{guild_id}" end)

        assign(command, :guild, guild)

      :error ->
        Logger.warn(fn -> "Could not find a guild with the id #{guild_id} in the cache." end)

        command
        |> set_response(content: Template.fetchguild_uncached())
        |> halt()
    end
  end
end
