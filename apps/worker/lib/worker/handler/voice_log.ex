defmodule Worker.Handler.VoiceLog do
  alias Rpc.{Cache, Rest}
  alias Util.Config.Guild
  alias Util.Locale
  def handle(nil, state), do: handle(%{channel_id: nil}, state)

  def handle(
        %{channel_id: old_channel_id},
        %{channel_id: new_channel_id, guild_id: guild_id, user_id: user_id}
      )
      when old_channel_id != new_channel_id do
    user =
      case Cache.fetch(User, user_id) do
        {:ok, user} ->
          user

        :error ->
          Rest.get_user!(user_id)
      end

    if channel_id = Guild.get_voice_log_channel(guild_id) do

      {key, color} =
        case {old_channel_id, new_channel_id} do
          {nil, _} ->
            {:LOC_VOICELOG_JOINED, 0x7CFC00}

          {_, nil} ->
            {:LOC_VOICELOG_LEFT, 0xFF4500}

          _ ->
            {:LOC_VOICELOG_MOVED, 0x3498DB}
        end

      embed = %{
        author: %{
          name: user.username,
          icon_url: Crux.Rest.CDN.user_avatar(user)
        },
        color: color,
        description:
          {key,
           user: to_string(user),
           new_channel: "<##{new_channel_id}>",
           old_channel: "<##{old_channel_id}>"},
        timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
      }

      locale = Locale.fetch!(guild_id)
      response = Locale.localize_response([embed: embed], locale)

      case Rest.create_message(channel_id, response) do
        {:ok, _message} ->
          :ok

        # Unknown channel
        {:error, %{code: 10003}} ->
          require Logger

          Logger.warn(fn ->
            "Voice log channel in #{guild_id} was deleted, removing it from configuration..."
          end)

          1 = Guild.delete_voice_log_channel(guild_id)

          :error

        {:error, error} ->
          require Logger

          Logger.error(fn ->
            """
            Failed to send voice log message to #{channel_id} in #{guild_id}:
            #{Exception.format(:error, error)}
            """
          end)

          :error
      end
    end
  end

  def handle(_, _), do: nil
end
