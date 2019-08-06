defmodule Rpc.Gateway do
  use Rpc, :gateway

  def voice_state_update(shard_id, guild_id, channel_id \\ nil, states \\ [])

  def voice_state_update(shard_id, guild_id, channel_id, states) when is_local() do
    command = ensure_loaded(Crux.Gateway.Command).voice_state_update(guild_id, channel_id, states)
    send_command(shard_id, command)
  end

  def voice_state_update(shard_id, guild_id, channel_id, states) do
    do_rpc()
  end

  def send_command(shard_id, command) when is_local() do
    ensure_loaded(Gateway.Application).name()
    |> ensure_loaded(Crux.Gateway.Connection).send_command(shard_id, command)
  end

  def send_command(shard_id, command) do
    do_rpc()
  end
end
