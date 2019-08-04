defmodule Rpc.LavaLink do
  use Rpc, :lavalink
  require Rpc

  @behaviour Rpc.Player.Commands

  def forward(data) when is_local() do
    require Logger
    Logger.debug(fn -> "Forwarding #{inspect(data)}" end)

    LavaLink.Player.name()
    |> ExLink.Connection.forward(data)
  end

  def forward(data) do
    do_rpc()
  end

  def resolve_identifier_and_fetch_tracks(identifier, requester) when is_local() do
    identifier
    |> LavaLink.Rest.resolve_identifier()
    |> LavaLink.Rest.fetch_tracks(requester)
  end

  def resolve_identifier_and_fetch_tracks(identifier, requester) do
    do_rpc()
  end

  @impl true
  def register(guild_id, channel_id, shard_id) when is_local() do
    send_call(guild_id, {:register, {channel_id, shard_id}})
  end

  @impl true
  def play(guild_id, tracks) when not is_list(tracks) do
    play(guild_id, [tracks])
  end

  def play(guild_id, tracks) when is_local() and is_list(tracks) do
    send_command(guild_id, {:play, tracks})
  end

  def play(guild_id, tracks) when is_list(tracks) do
    do_rpc()
  end

  @impl true
  def skip(guild_id, count) when is_local() do
    send_command(guild_id, {:skip, count})
  end

  def skip(guild_id, count) do
    do_rpc()
  end

  @impl true
  def remove(guild_id, position, count) when is_local() do
    send_command(guild_id, {:remove, {position, count}})
  end

  def remove(guild_id, position, count) do
    do_rpc()
  end

  @impl true
  def loop(guild_id) when is_local() do
    send_command(guild_id, :loop)
  end

  def loop(guild_id) do
    do_rpc()
  end

  @impl true
  def loop(guild_id, new_state) when is_local() do
    send_command(guild_id, {:loop, new_state})
  end

  def loop(guild_id, new_state) do
    do_rpc()
  end

  @impl true
  def shuffle(guild_id) when is_local() do
    send_command(guild_id, :shuffle)
  end

  def shuffle(guild_id) do
    do_rpc()
  end

  @impl true
  def pause(guild_id) when is_local() do
    send_command(guild_id, :pause)
  end

  def pause(guild_id) do
    do_rpc()
  end

  @impl true
  def resume(guild_id) when is_local() do
    send_command(guild_id, :resume)
  end

  def resume(guild_id) do
    do_rpc()
  end

  # summon

  @impl true
  def now_playing(guild_id) when is_local() do
    send_command(guild_id, :now_playing)
  end

  def now_playing(guild_id) do
    do_rpc()
  end

  @impl true
  def queue(guild_id) when is_local() do
    send_command(guild_id, :queue)
  end

  def queue(guild_id) do
    do_rpc()
  end

  defp send_command(guild_id, command) do
    LavaLink.Player.name()
    |> ExLink.get_player(guild_id)
    |> case do
      :error ->
        :error

      pid ->
        ExLink.Player.call(pid, {:command, command})
    end
  end

  defp send_call(guild_id, data) do
    LavaLink.Player.name()
    |> ExLink.ensure_player(guild_id)
    |> ExLink.Player.call(data)
  end
end
