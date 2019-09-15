defmodule Worker.MiddleWare.HasPermissions do
  @moduledoc """
    Ensures that either the member of the command or the current user has specific permissions.

    > Implicitly fetches the guild and both members, see `Worker.MiddleWare.{FetchGuild, FetchMember}`

    Is a noop in dms.

    Possible options are:
    * `{Permissions.resolvable(), (Command.t() -> snowflake()) | snowflake() | :current | nil, :self | :member}`
      The required permissions, a channel id or current, if for a channel, :self or :member as the target
    * `{Permissions.resolvable(), (Command.t() -> snowflake()) | snowflake() | :current | nil, :self | :member, (Command.t()) -> boolean())}`
      Optionally a predicate to bypass this middle ware.
  """

  use Worker.MiddleWare

  alias Worker.MiddleWare.OwnerOnly
  alias Rpc.{Cache, Sentry}
  alias Util.Locale.Template

  alias Crux.Structs.Permissions

  require Rpc.Sentry

  def required(), do: [Worker.MiddleWare.FetchGuild, {Worker.MiddleWare.FetchMember, :both}]

  # Do not require permissions in dms, there aren't any there anyway
  def call(%{message: %{guild_id: nil}} = command, _opts) do
    Sentry.debug("DM; bypasses.", "middleware")

    command
  end

  # Only require permissions if a specific condition is met
  def call(command, {permissions, channel_id, target, predicate}) do
    if predicate.(command) do
      Sentry.debug("Predicate evaluated to true; bypasses.", "middleware")

      command
    else
      call(command, {permissions, channel_id, target})
    end
  end

  def call(command, {permissions, func, target}) when is_function(func, 1) do
    call(command, {permissions, func.(command), target})
  end

  def call(
        %{assigns: %{guild: guild} = assigns, message: message} = command,
        {permissions, channel_id, target}
      )
      when target in [:member, :self] do
    member = if target == :self, do: assigns.member, else: message.member

    if OwnerOnly.owner?(member) do
      Sentry.debug("Owner bypasses.", "middleware")

      command
    else
      channel = get_channel(channel_id, message)

      Sentry.debug(
        "Checking #{target} in #{channel_id || :guild} for #{inspect(permissions)}.",
        "middleware"
      )

      Permissions.implicit(member, guild, channel)
      |> Permissions.missing(permissions)
      |> Permissions.to_list()
      |> case do
        [] ->
          command

        missing ->
          missing =
            missing
            |> Enum.map_join(", ", fn perm ->
              perm
              |> Atom.to_string()
              |> String.split("_")
              |> Enum.map_join(" ", &String.capitalize/1)
            end)

          command
          |> set_response(content: get_response(target, missing))
          |> halt()
      end
    end
  end

  defp get_response(:self, permissions) do
    Template.haspermissions_self_missing_permissions(permissions)
  end

  defp get_response(:member, permissions) do
    Template.haspermissions_member_missing_permissions(permissions)
  end

  defp get_channel(nil, _message), do: nil

  defp get_channel(:current, %{channel_id: channel_id}) do
    Cache.fetch!(Channel, channel_id)
  end

  defp get_channel(channel_id, _message) do
    Cache.fetch!(Channel, channel_id)
  end
end
