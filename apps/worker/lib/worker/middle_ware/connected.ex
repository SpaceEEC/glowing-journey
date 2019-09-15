defmodule Worker.MiddleWare.Connected do
  @moduledoc """
    Ensures the user or both are connected and in the same or not the same channel.
    Depending on command

    > Implicitly fetches the current guild, see `Worker.MiddleWare.FetchGuild`.

    The name of the command must be specified as atom as option
  """

  use Worker.MiddleWare
  alias Util.Locale.Template

  # if bot is connected it must be in the same channel, except on summon, there it's the opposite

  @impl true
  def required(), do: [Worker.MiddleWare.FetchGuild]

  def get_channel_id(user_id, states) do
    case states do
      %{^user_id => %{channel_id: channel_id}} -> channel_id
      _ -> nil
    end
  end

  def connected?(user_id, states) do
    get_channel_id(user_id, states) != nil
  end

  @impl true
  def call(
        %Crux.Extensions.Command{
          message: %{author: %{id: user_id}},
          assigns: %{guild: %{voice_states: voice_states}}
        } = command,
        command_atom
      ) do
    bot_id = Worker.Commands.get_user_id()

    cond do
      # Now playing, save, and queue only require the bot to be connected
      command_atom in [:now_playing, :save, :queue] ->
        if connected?(bot_id, voice_states) do
          command
        else
          command
          |> set_response(content: Template.connected_bot_not_connected())
          |> halt()
        end

      # All other commands require the user to be connected
      not connected?(user_id, voice_states) ->
        command
        |> set_response(content: Template.connected_user_not_connected())
        |> halt()

      # In case of summon the bot must be connected and in a different channel
      command_atom == :summon ->
        cond do
          # Not connected
          not connected?(bot_id, voice_states) ->
            command
            |> set_response(content: Template.connected_summon_not_connected())
            |> halt()

          # Same channel
          get_channel_id(user_id, voice_states) == get_channel_id(bot_id, voice_states) ->
            command
            |> set_response(content: Template.connected_summon_same_channel())
            |> halt()

          true ->
            command
        end

      # The bot does not have to be connected in order to `play`
      command_atom == :play and not connected?(bot_id, voice_states) ->
        command

      # For all other commands, both must be in the same channel
      get_channel_id(user_id, voice_states) == get_channel_id(bot_id, voice_states) ->
        command

      # Bot is not connected
      not connected?(bot_id, voice_states) ->
        command
        |> set_response(content: Template.connected_bot_not_connected())
        |> halt()

      # User is not connected
      true ->
        command
        |> set_response(content: Template.connected_user_not_connected())
        |> halt()
    end
  end
end
