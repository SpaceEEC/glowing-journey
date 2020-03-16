defmodule Worker.Command.Music.Save do
  use Worker.Command

  alias Rpc.LavaLink
  alias Rpc.LavaLink.Track

  @impl true
  def description(), do: Template.save_description()
  @impl true
  def usages(), do: Template.save_usages()
  @impl true
  def examples(), do: Template.save_examples()
  @impl true
  def disabled(), do: Template.music_disabled()

  @impl true
  def triggers(), do: ["save"]

  @impl true
  def required(), do: [MiddleWare.GuildOnly, {MiddleWare.Connected, :save}]

  @impl true
  def call(%{message: %{author: author, guild_id: guild_id} = message} = command, _) do
    embed =
      LavaLink.now_playing(guild_id)
      |> Track.to_embed(:save)

    case Rest.create_reaction(message, "💾") do
      :ok ->
        nil

      {:error, error} ->
        require Rpc.Sentry
        Rpc.Sentry.warn("Adding a reaction failed: #{inspect(error)}", "command")
        Sentry.capture_exception(error)
    end

    command
    |> set_response_channel(Rest.create_dm!(author))
    |> set_response(embed: embed)
  end
end
