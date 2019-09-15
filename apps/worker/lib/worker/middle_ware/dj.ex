defmodule Worker.MiddleWare.DJ do
  @moduledoc """
    Ensures the command is being ran in the dj channel by someone with a dj role.
    If either or both value is not configured the relevant check is skipped.

    Options:
    * `(Commaand.t() -> as_boolean())`
      Predicate function to bypass this middle ware
  """
  use Worker.MiddleWare

  alias Util.Config.Guild
  alias Util.Locale.Template

  require Logger

  @impl true
  def required() do
    [MiddleWare.GuildOnly, MiddleWare.FetchGuild, {MiddleWare.FetchMember, :member}]
  end

  @impl true
  def call(command, predicate) when is_function(predicate, 1) do
    if predicate.(command) do
      Logger.debug(fn -> "Predicate evaluated to true; bypasses." end)

      command
    else
      call(command, [])
    end
  end

  def call(
        %{
          message: %{member: %{roles: roles}, channel_id: channel_id, guild_id: guild_id},
          assigns: %{guild: guild}
        } = command,
        _
      ) do
    dj_channel_id =
      guild_id
      |> Guild.get_dj_channel()
      |> ensure_channel(guild)

    dj_role_id =
      guild_id
      |> Guild.get_dj_role()
      |> ensure_role(guild)

    cond do
      dj_channel_id && dj_channel_id != channel_id ->
        command
        |> set_response(content: Template.dj_channel("<##{dj_channel_id}>"))
        |> halt()

      dj_role_id && not MapSet.member?(roles, dj_role_id) ->
        command
        |> set_response(content: Template.dj_role("@#{guild.roles[dj_role_id].name}"))
        |> halt()

      true ->
        command
    end
  end

  defp ensure_channel(nil, _), do: nil

  defp ensure_channel(dj_channel_id, %{id: guild_id, channels: channels})
       when is_integer(dj_channel_id) do
    if MapSet.member?(channels, dj_channel_id) do
      dj_channel_id
    else
      Logger.debug(fn -> "Configured dj channel in guild #{guild_id} deleted; Removing..." end)

      # Channel does not exist, remove from config
      1 = Guild.delete_dj_channel(guild_id)

      nil
    end
  end

  defp ensure_role(nil, _), do: nil

  defp ensure_role(dj_role_id, %{roles: roles})
       when :erlang.is_map_key(dj_role_id, roles) do
    dj_role_id
  end

  # Roles does not exist, remove from config
  defp ensure_role(dj_role_id, %{id: guild_id})
       when is_integer(dj_role_id) do
    Logger.debug(fn -> "Configured dj role in guild #{guild_id} deleted; Removing..." end)

    1 = Guild.delete_dj_role(guild_id)
    nil
  end
end
