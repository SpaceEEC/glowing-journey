defmodule Worker.Command.Config.ConfigStatus do
  use Worker.Command

  alias Util.Config.Guild

  @impl true
  def description(), do: Template.configstatus_description()

  @impl true
  def usages(), do: Template.configstatus_usages()

  @impl true
  def examples(), do: Template.configstatus_examples()

  @impl true
  def triggers(), do: ["config-status", "conf-status"]
  @impl true
  def required() do
    [MiddleWare.GuildOnly, {MiddleWare.HasPermissions, {:manage_guild, nil, :member}}]
  end

  @impl true
  def call(%{message: %{guild_id: guild_id}} = command, _) do
    config =
      guild_id
      |> Guild.get_all()

    longest = Guild.get_keys() |> Enum.map(&String.length/1) |> Enum.max()

    config =
      Guild.get_keys()
      |> Enum.map_join("\n", fn key ->
        value = Map.get(config, key)

        key =
          key
          |> String.replace("_", "")
          |> String.pad_trailing(longest)

        "#{key} :: #{value}"
      end)

    set_response(command, content: Template.configstatus_response(config))
  end
end
