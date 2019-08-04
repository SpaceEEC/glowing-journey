defmodule Rpc.Logger do
  def format(level, message, timestamp, meta)
      when not is_binary(message) do
    message =
      try do
        to_string(message)
      rescue
        _ ->
          inspect(message)
      end

    format(level, message, timestamp, meta)
  end

  def format(level, message, timestamp, meta) do
    level = "[#{level |> Atom.to_string() |> String.pad_trailing(5)}]"

    module =
      case Keyword.fetch(meta, :module) do
        {:ok, mod} ->
          "[#{mod |> to_string() |> get_mod_string()}"

        _ ->
          "[<?>"
      end

    function =
      case Keyword.fetch(meta, :function) do
        {:ok, fun} ->
          ".#{fun}]"

        _ ->
          ".<?>]"
      end

    "#{level}#{module}#{function}: #{message}\n"
  rescue
    e ->
      "formatting failed #{inspect({level, message, timestamp, meta})}\nerror:#{e}"
  end

  defp get_mod_string("Elixir." <> mod) do
    mod
  end

  defp get_mod_string(mod), do: mod
end
