defmodule Rpc.Player.Commands do
  @type guild_id :: Crux.Rest.snowflake()
  @type track :: LavaLink.Track.t()
  @type tracks :: [track]
  @type queue :: :queue.t(track)

  @doc "Technically not a command, has to be implemented nevertheless"
  @callback register(guild_id, channel_id :: Crux.Rest.snowflake(), shard_id :: non_neg_integer) ::
              :ok

  @callback play(guild_id, tracks) :: {start :: boolean, tracks}
  @callback skip(guild_id, count :: pos_integer) :: tracks
  @callback remove(guild_id, position :: pos_integer, count :: pos_integer) :: tracks | nil
  @callback loop(guild_id) :: boolean
  @callback loop(guild_id, new_state :: boolean) :: boolean
  @callback shuffle(guild_id) :: :ok
  @callback pause(guild_id) :: boolean
  @callback resume(guild_id) :: boolean
  @callback now_playing(guild_id) :: track
  @callback queue(guild_id) :: queue
  @callback volume(guild_id) :: non_neg_integer()
  @callback volume(guild_id, non_neg_integer()) :: :ok | :error
end
