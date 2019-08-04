defmodule Worker.MiddleWare.Connected do
  @moduledoc """
    Ensures the user or both are connected and in the same or not the same channel.
    Depending on command

    > Implicitly fetches the current guild, see `Worker.MiddleWare.FetchGuild`.

    The name of the command must be specified as atom as option
  """

  use Worker.MiddleWare

  # if bot is connected it must be in the same channel, except on summon, there it's the opposite

  @bot_id Worker.Commands.get_user_id()

  @impl true
  def required(), do: [Worker.MiddleWare.FetchGuild]

  defmacrop is_connected(user_id, states) do
    quote do
      :erlang.is_map_key(unquote(user_id), unquote(states)) and
        not is_nil(
          :erlang.map_get(:channel_id, :erlang.map_get(unquote(user_id), unquote(states)))
        )
    end
  end

  defmacrop get_channel_id(user_id, states) do
    quote do
      :erlang.map_get(:channel_id, :erlang.map_get(unquote(user_id), unquote(states)))
    end
  end

  @impl true
  def call(
        %Crux.Extensions.Command{
          assigns: %{guild: %{voice_states: voice_states}}
        } = command,
        command_atom
      )
      when command_atom in [:now_playing, :save, :queue] do
    if is_connected(@bot_id, voice_states) do
      command
    else
      command
      |> set_response(content: :LOC_CONNECTED_BOT_NOT_CONNECTED)
      |> halt()
    end
  end

  def call(
        %Crux.Extensions.Command{
          message: %{author: %{id: user_id}},
          assigns: %{guild: %{voice_states: voice_states}}
        } = command,
        _command_atom
      )
      when not is_connected(user_id, voice_states) do
    command
    |> set_response(content: :LOC_CONNECTED_USER_NOT_CONNECTED)
    |> halt()
  end

  ### summon exceptions
  def call(
        %Crux.Extensions.Command{
          assigns: %{guild: %{voice_states: voice_states}}
        } = command,
        :summon
      )
      when not is_connected(@bot_id, voice_states) do
    command
    |> set_response(content: :LOC_CONNECTED_SUMMON_NOT_CONNECTED)
    |> halt()
  end

  def call(
        %Crux.Extensions.Command{
          message: %{author: %{id: user_id}},
          assigns: %{guild: %{voice_states: voice_states}}
        } = command,
        :summon
      )
      when get_channel_id(user_id, voice_states) != get_channel_id(@bot_id, voice_states) do
    command
  end

  # only possible option now: same channel
  def call(command, :summon) do
    command
    |> set_response(content: :LOC_CONNECTED_SUMMON_SAME_CHANNEL)
    |> halt()
  end

  ### summon exceptions end

  ### play exception
  def call(
        %Crux.Extensions.Command{
          assigns: %{guild: %{voice_states: voice_states}}
        } = command,
        :play
      )
      when not is_connected(@bot_id, voice_states) do
    command
  end

  # if the bot is in the same channel it always works
  def call(
        %Crux.Extensions.Command{
          message: %{author: %{id: user_id}},
          assigns: %{guild: %{voice_states: voice_states}}
        } = command,
        _
      )
      when get_channel_id(user_id, voice_states) == get_channel_id(@bot_id, voice_states) do
    command
  end

  def call(
        %Crux.Extensions.Command{
          assigns: %{guild: %{voice_states: voice_states}}
        } = command,
        _command_atom
      )
      when not is_connected(@bot_id, voice_states) do
    command
    |> set_response(content: :LOC_CONNECTED_BOT_NOT_CONNECTED)
    |> halt()
  end

  def call(command, _command_atom) do
    command
    |> set_response(content: :LOC_CONNECTED_DIFFERENT_CHANNELS)
    |> halt()
  end
end
