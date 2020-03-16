defmodule Worker do
  def start_link(event) do
    Task.start_link(__MODULE__, :handle_event, [event])
  end

  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      restart: :temporary
    }
  end

  def handle_event({:MESSAGE_CREATE, %{author: %{bot: false}} = message, shard_id}) do
    Worker.Commands.handle(message, shard_id)
  end

  def handle_event({:GUILD_MEMBER_ADD, member, _shard_id}) do
    Worker.Handler.JoinLeaveMessage.handle_join(member)
  end

  def handle_event({:GUILD_MEMBER_REMOVE, {data, %{id: guild_id}}, shard_id}) do
    handle_event({:GUILD_MEMBER_REMOVE, {data, guild_id}, shard_id})
  end

  def handle_event({:GUILD_MEMBER_REMOVE, {%{user: user_id}, guild_id}, shard_id}) do
    handle_event({:GUILD_MEMBER_REMOVE, {user_id, guild_id}, shard_id})
  end

  def handle_event({:GUILD_MEMBER_REMOVE, {%{id: user_id}, guild_id}, shard_id}) do
    handle_event({:GUILD_MEMBER_REMOVE, {user_id, guild_id}, shard_id})
  end

  def handle_event({:GUILD_MEMBER_REMOVE, {user_id, guild_id}, _shard_id}) do
    Worker.Handler.JoinLeaveMessage.handle_remove(%{user: user_id, guild_id: guild_id})
  end

  # def handle_event({:VOICE_SERVER_UPDATE, data, _shard_id}) do
  #   Rpc.LavaLink.forward(data)
  # end

  def handle_event({:VOICE_STATE_UPDATE, {old_state, new_state}, _shard_id}) do
    # new_state
    # |> Map.from_struct()
    # |> Rpc.LavaLink.forward()

    Worker.Handler.VoiceLog.handle(old_state, new_state)
  end

  def handle_event(_), do: nil
end
