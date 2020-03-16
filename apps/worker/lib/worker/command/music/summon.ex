defmodule Worker.Command.Music.Summon do
  use Worker.Command

  alias Rpc.Gateway

  @impl true
  def description(), do: Template.summon_description()
  @impl true
  def usages(), do: Template.summon_usages()
  @impl true
  def examples(), do: Template.summon_examples()
  @impl true
  def disabled(), do: Template.music_disabled()

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

    set_response(command, content: Template.summon_summoned())
  end
end
