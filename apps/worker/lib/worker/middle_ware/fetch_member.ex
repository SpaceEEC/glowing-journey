defmodule Worker.MiddleWare.FetchMember do
  @moduledoc """
    Fetches the member of the command, the current user as member, or both.

    > Implicitly fetches the current guild, see `Worker.MiddleWare.FetchGuild`.

    The member of the command can be found under `message.member`.
    The current user as member will be assigned to `member`.

    If the message originates from a dm, `nil` will be assigned.

    Possible options:
    * `:member` - Fetches the member of the command
    * `:self` - Fetches the current user as member
    * `:both` - Fetches both
  """

  alias Util.Locale.Template

  use Worker.MiddleWare

  alias Rpc.Sentry
  require Sentry

  def required(), do: [Worker.MiddleWare.FetchGuild]

  # Not in a guild
  def call(%{message: %{guild_id: nil}} = command, :member), do: command

  # Not in a guild, assign `nil`

  def call(%{message: %{guild_id: nil}} = command, :self) do
    Sentry.debug("DM; assigning nil.", "middleware")

    command
    |> assign(:member, nil)
  end

  # Fetch both
  def call(command, :both) do
    command
    |> call(:member)
    |> call(:self)
  end

  # :member already cached
  def call(%{message: %{member: member}} = command, :member)
      when not is_nil(member) do
    command
  end

  # :self already cached
  def call(%{assigns: %{member: member}} = command, :self)
      when not is_nil(member) do
    command
  end

  def call(%{message: message, assigns: %{guild: guild}} = command, target)
      when target in [:member, :self] do
    user = get_target(message, target)
    Sentry.debug("Fetching #{target} #{user.id}...", "middleware")

    with :error <- Map.fetch(guild.members, user.id),
         {:ok, member} <- Rest.get_guild_member(guild, user) do
      Sentry.debug("Fetched #{user.id} via rest.", "middleware")

      member = %{member | guild_id: guild.id}
      guild = %{guild | members: &Map.put(&1, user.id, member)}

      command = assign(command, :guild, guild)
      Cache.insert(Guild, member)

      add_member(command, message, member)
    else
      # Map.fetch from guild.members
      {:ok, member} ->
        Sentry.debug("Fetched #{user.id} from cache.", "middleware")

        add_member(command, message, member)

      # Rest.get_guild_member failed
      {:error, error} ->
        Sentry.error(
          """
          An error occured while fetching #{user} (#{user.id}) \
          in guild #{guild.name} (#{guild.id})
          #{inspect(error)}
          """,
          "middleware"
        )

        command
        |> set_response(content: Template.fetchmember_failed())
        |> halt()
    end
  end

  defp get_target(_message, :self), do: Cache.me!()
  defp get_target(%{author: author}, :member), do: author

  # :member
  defp add_member(
         %{message: %{author: %{id: user_id}}} = command,
         message,
         %{user: user_id} = member
       ) do
    message = %{message | member: member}
    %{command | message: message}
  end

  # :self
  defp add_member(command, _message, member) do
    command
    |> assign(:member, member)
  end
end
