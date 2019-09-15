defmodule Worker.Command.Music.Stop do
  use Worker.Command

  @impl true
  def description(), do: Template.stop_description()
  @impl true
  def usages(), do: Template.stop_usages()
  @impl true
  def examples(), do: Template.stop_examples()

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

    set_response(command, content: Template.leave_left())
  end
end
