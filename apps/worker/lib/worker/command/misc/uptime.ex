defmodule Worker.Command.Misc.Uptime do
  use Worker.Command

  @impl true
  def description(), do: Template.uptime_description()
  @impl true
  def usages(), do: Template.uptime_usages()
  @impl true
  def examples(), do: Template.uptime_examples()

  @impl true
  def triggers(), do: ["uptime"]

  @impl true
  def call(command, _opts) do
    data =
      [Node.self() | Node.list()]
      |> fetch_nodes_data()

    longest =
      data
      |> Map.keys()
      |> Enum.max_by(fn node -> String.length(node) end)
      |> String.length()

    content =
      Enum.map_join(data, "\n", fn {node, uptime} ->
        "#{String.pad_trailing(node, longest)} :: #{uptime}"
      end)

    set_response(command, content: Template.uptime(content))
  end

  defp fetch_nodes_data(nodes) do
    nodes
    |> Map.new(fn node ->
      uptime =
        node
        |> fetch_uptime()
        |> format_uptime()

      node = format_node_name(node)

      {node, uptime}
    end)
  end

  defp fetch_uptime(node) do
    node
    |> :rpc.call(:erlang, :statistics, [:wall_clock])
    |> elem(0)
  end

  defp format_uptime(uptime) do
    uptime = div(uptime, 1000)

    seconds =
      uptime
      |> rem(60)
      |> to_string
      |> String.pad_leading(2, "0")

    uptime = div(uptime, 60)

    minutes =
      uptime
      |> rem(60)
      |> to_string
      |> String.pad_leading(2, "0")

    uptime = div(uptime, 60)

    hours =
      uptime
      |> rem(24)
      |> to_string
      |> String.pad_leading(2, "0")

    days = div(uptime, 24)

    uptime =
      if days == 0 do
        ""
      else
        # TODO: localizing?
        "#{days} days "
      end

    "#{uptime}#{hours}:#{minutes}:#{seconds}"
  end

  defp format_node_name(:nonode@nohost) do
    "Local"
  end

  defp format_node_name(:"offline@127.0.0.1") do
    "Local"
  end

  defp format_node_name(node) when is_atom(node) do
    node
    |> to_string()
    |> format_node_name()
  end

  defp format_node_name("bot_" <> node) do
    node
    |> format_node_name()
  end

  defp format_node_name(node) when is_binary(node) do
    node
    |> String.split("@")
    |> List.first()
    |> String.capitalize()
  end
end
