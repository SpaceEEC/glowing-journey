defmodule Worker.Command.Hidden.Channels do
  use Worker.Command

  @impl true
  def description(), do: "Shows a sorted channel list"
  @impl true
  def examples(), do: "Example: `channels`"
  @impl true
  def usages(), do: "Usage: `channels`"

  @impl true
  def triggers(), do: ["channels"]

  @impl true
  def required(), do: [Worker.MiddleWare.GuildOnly, Worker.MiddleWare.FetchGuild]

  @impl true
  def call(%{message: message} = command, _) do
    channels =
      Guild
      |> Cache.fetch!(message.guild_id)
      |> Map.get(:channels)
      |> MapSet.to_list()
      |> Cache.get_channels()

    child_channels =
      channels
      |> Enum.reject(fn channel -> channel.type == 4 end)
      |> Enum.group_by(&Map.get(&1, :parent_id))

    categories =
      for %{type: 4} = category <- channels,
          into: %{} do
        children =
          child_channels
          |> Map.get(category.id, [])
          |> Enum.sort(&compare_channels/2)

        {category, children}
      end
      |> Enum.sort(&compare_channels/2)

    res =
      categories
      |> Enum.map_join("\n\n", fn {category, children} ->
        "#{category}\n  #{Enum.map_join(children, "\n  ", &to_string/1)}"
      end)

    set_response(command, content: res)
  end

  # Allow sorting of maps
  def compare_channels({channel1, _}, {channel2, _}) do
    compare_channels(channel1, channel2)
  end

  # Voice channels are always below text / news / store / whatever
  def compare_channels(%{type: type1}, %{type: type2})
      when 2 in [type1, type2] and type1 != type2 do
    type2 == 2
  end

  def compare_channels(%{position: position1}, %{position: position2})
      when position1 != position2 do
    position1 < position2
  end

  # If positions are the same, compare ids
  def compare_channels(%{id: id1}, %{id: id2}) do
    id1 < id2
  end
end
