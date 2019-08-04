defmodule Worker.Command.Music.Stop do
  use Worker.Command

  @impl true
  def description(), do: :LOC_STOP_DESCRIPTION
  @impl true
  def usages(), do: :LOC_STOP_USAGES
  @impl true
  def examples(), do: :LOC_STOP_EXAMPLES

  @impl true
  def triggers(), do: ["stop", "leave"]

  @impl true
  def required(),
    do: [
      MiddleWare.GuildOnly,
      {MiddleWare.Connected, :stop},
      {MiddleWare.DJ, &MiddleWare.OwnerOnly.owner?/1}
    ]

  @impl true
  def call(
        %{
          message: %{guild_id: guild_id},
          shard_id: shard_id
        } = command,
        _
      ) do
    Rpc.Gateway.voice_state_update(shard_id, guild_id, nil)

    set_response(command, content: :LOC_LEAVE_LEFT)
  end
end
