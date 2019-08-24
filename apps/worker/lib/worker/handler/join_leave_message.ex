defmodule Worker.Handler.JoinLeaveMessage do
  alias Rpc.{Cache, Rest}
  alias Util.Config.Guild

  alias Crux.Structs.Permissions

  def handle_join(member) do
    handle(
      member,
      &Guild.get_join_message/1,
      &Guild.get_join_channel/1,
      &Guild.delete_join_channel/1
    )
  end

  def handle_remove(data) do
    handle(
      data,
      &Guild.get_leave_message/1,
      &Guild.get_leave_channel/1,
      &Guild.delete_leave_channel/1
    )
  end

  defp handle(
         %{guild_id: guild_id, user: user},
         get_message,
         get_channel,
         delete_channel
       ) do
    message = get_message(guild_id, get_message)
    user = get_user(user)
    channel = get_channel(guild_id, get_channel, delete_channel)
    guild = get_guild(guild_id)

    with {:ok, message} <- message,
         {:ok, user} <- user,
         {:ok, channel} <- channel,
         {:ok, guild} <- guild do
      me_member = get_me_member(guild, Worker.Commands.get_user_id())

      message =
        message
        |> String.replace(":member:", "`@#{user.username}##{user.discriminator}`")
        |> String.replace(":mention:", to_string(user))
        |> String.replace(":guild:", guild.name)

      permissions = Permissions.implicit(me_member, guild, channel)

      if Permissions.has(permissions, [:view_channel, :send_messages]) do
        require Logger

        case Rest.create_message(channel, content: message) do
          {:ok, _message} ->
            :ok

          {:error, %{code: 10003}} ->
            delete_channel.(guild_id)

            Logger.info(fn ->
              "Removing deleted channel #{channel.id} in guild #{guild_id} from the configuration."
            end)

            :error

          {:error, error} ->
            Logger.error(fn ->
              """
              Sending join / leave message to #{channel.id} in guild #{guild_id} failed.
              #{Exception.format(:error, error)}
              """
            end)

            :error
        end
      end
    end
  end

  @spec get_message(any, any) :: {:ok, String.t()} | :error
  defp get_message(guild_id, get_message) do
    case get_message.(guild_id) do
      nil -> :error
      message -> {:ok, message}
    end
  end

  @spec get_user(any) :: {:ok, Crux.Structs.User.t()} | :error
  defp get_user(user_id) do
    with :error <- Cache.fetch(User, user_id),
         {:error, reason} <- Rest.get_user(user_id) do
      require Logger

      Logger.error(fn ->
        """
        Fetching the user #{user_id} failed
        #{Exception.format(:error, reason)}
        """
      end)

      :error
    end
  end

  @spec get_channel(any, any, any) :: {:o, Crux.Structs.Channel.t()} | :error
  defp get_channel(guild_id, get_channel, delete_channel) do
    case get_channel.(guild_id) do
      nil ->
        :error

      channel_id ->
        require Logger

        case Cache.fetch(Channel, channel_id) do
          {:ok, %{type: type}} when type != 0 ->
            Logger.info(fn ->
              "Removing non text channel #{channel_id} in guild #{guild_id} from the configuration."
            end)

            delete_channel.(guild_id)

            :error

          {:ok, _channel} = tuple ->
            tuple

          :error ->
            Logger.info(fn ->
              "Removing deleted channel #{channel_id} in guild #{guild_id} from the configuration."
            end)

            delete_channel.(guild_id)

            :error
        end
    end
  end

  @spec get_guild(any) :: {:o, Crux.Structs.Guild.t()} | :error
  defp get_guild(guild_id), do: Cache.fetch(Elixir.Guild, guild_id)

  @spec get_me_member(
          Crux.Structs.Guild.t(),
          Crux.Rest.snowflake()
        ) :: Crux.Structs.Member.t() | no_return()
  defp get_me_member(%{members: members, id: guild_id}, user_id) do
    Map.get_lazy(members, user_id, fn -> Rest.get_guild_member!(guild_id, user_id) end)
  end
end
