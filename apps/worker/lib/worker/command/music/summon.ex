defmodule Worker.Command.Music.Summon do
  use Worker.Command

  alias Rpc.Gateway

  @impl true
  def description(), do: :LOC_SUMMON_DESCRIPTION
  @impl true
  def usages(), do: :LOC_SUMMON_USAGES
  @impl true
  def examples(), do: :LOC_SUMMON_EXAMPLES

  @impl true
  def triggers(), do: ["summon"]
  @impl true
  def required(),
    do: [
      MiddleWare.GuildOnly,
      {MiddleWare.Connected, :summon},
      {MiddleWare.DJ, &MiddleWare.OwnerOnly.owner?/1}
    ]

  @impl true
  def call(
        %Crux.Extensions.Command{
          message: %{author: %{id: user_id}, guild_id: guild_id},
          assigns: %{guild: %{voice_states: voice_states}},
          shard_id: shard_id
        } = command,
        _
      ) do
    :ok = Gateway.voice_state_update(shard_id, guild_id, voice_states[user_id].channel_id)

    set_response(command, content: :LOC_SUMMON_SUMMONED)
  end
end
