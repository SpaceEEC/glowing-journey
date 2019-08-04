defmodule Worker.Command.Config.ConfigStatus do
  use Worker.Command

  alias Worker.Config.Guild

  @impl true
  def description(), do: :LOC_CONFIGSTATUS_DESCRIPTION

  @impl true
  def usages(), do: :LOC_CONFIGSTATUS_USAGES
  @impl true
  @spec examples :: :LOC_CONFIGSTATUS_EXAMPLES
  def examples(), do: :LOC_CONFIGSTATUS_EXAMPLES

  @impl true
  def triggers(), do: ["config-status", "conf-status"]
  @impl true
  def required(), do: [Worker.MiddleWare.GuildOnly]

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

    set_response(command, content: {:LOC_CONFIGSTATUS_RESPONSE, config: config})
  end
end
