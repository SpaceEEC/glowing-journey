defmodule Worker.Handler.VoiceLog do
  alias Rpc.{Cache, Rest}
  alias Util.Config.Guild
  alias Util.Locale
  alias Util.Locale.Template

  require Rpc.Sentry

  def handle(nil, state), do: handle(%{channel_id: nil}, state)

  def handle(
        %{channel_id: old_channel_id},
        %{channel_id: new_channel_id, guild_id: guild_id, user_id: user_id}
      )
      when old_channel_id != new_channel_id do
    Sentry.Context.set_user_context(%{
      user_id: user_id,
      guild_id: guild_id,
      new_channel_id: new_channel_id,
      old_channel_id: old_channel_id
    })

    user =
      case Cache.fetch(User, user_id) do
        {:ok, user} ->
          user

        :error ->
          Rest.get_user!(user_id)
      end

    user_mention = to_string(user)
    new_channel = "<##{new_channel_id}>"
    old_channel = "<##{old_channel_id}>"

    if channel_id = Guild.get_voice_log_channel(guild_id) do
      Sentry.Context.set_user_context(%{
        voice_log_channel_id: channel_id
      })

      {description, color} =
        case {old_channel_id, new_channel_id} do
          {nil, _} ->
            {Template.voicelog_joined(user_mention, new_channel), 0x7CFC00}

          {_, nil} ->
            {Template.voicelog_left(user_mention, old_channel), 0xFF4500}

          _ ->
            {Template.voicelog_moved(user_mention, old_channel, new_channel), 0x3498DB}
        end

      embed = %{
        author: %{
          name: user.username,
          icon_url: Crux.Rest.CDN.user_avatar(user)
        },
        color: color,
        description: description,
        timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
      }

      locale = Locale.fetch!(guild_id)
      response = Locale.localize_response([embed: embed], locale)

      Sentry.Context.set_user_context(%{
        response: inspect(response)
      })

      case Rest.create_message(channel_id, response) do
        {:ok, _message} ->
          :ok

        # Unknown channel
        {:error, %{code: 10003}} ->
          Rpc.Sentry.warn(
            "Voice log channel in #{guild_id} was deleted, removing it from configuration...",
            "handler"
          )

          Sentry.capture_message("Removed deleted voice log channel from the configuration")

          1 = Guild.delete_voice_log_channel(guild_id)

          :error

        {:error, error} ->
          Rpc.Sentry.error(
            """
            Failed to send voice log message to #{channel_id} in #{guild_id}:
            #{Exception.format(:error, error)}
            """,
            "handler"
          )

          Sentry.capture_exception(error)

          :error
      end
    end
  end

  def handle(_, _), do: nil
end
