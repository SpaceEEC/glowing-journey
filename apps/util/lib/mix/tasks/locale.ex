defmodule Mix.Tasks.Locale do
  use Mix.Task

  @file_template """
  defmodule Util.Locale.{{lang}} do
    @behaviour Util.Locale

    def code(), do: "{{lang}}"
    def friendly_name(), do: "{{friendly_name}}"

  {{others}}
    @localization %{}
                  {{merges}}

    @spec get_string(atom()) :: String.t() | no_return()
    def get_string(key) do
      Map.fetch!(@localization, key)
    end
  end
  """

  @other_template """
    @{{name}} %{
      {{entries}}
    }
  """

  @merge_template """
  |> Map.merge(@{{name}}, &Util.Locale.raise_duplicate_key/3)
  """

  defp get_keys() do
    apps_dir =
      __DIR__
      |> Path.split()
      |> Enum.slice(0..-5)
      |> Path.join()

    locale_prefix = Path.join(apps_dir, Path.join(["util", "lib", "util", "locale"]))

    apps_dir
    |> Path.split()
    |> Enum.concat(["**", "*.ex"])
    |> Path.join()
    |> Path.wildcard()
    # Filter locale files
    |> Enum.filter(fn
      path ->
        not String.starts_with?(path, locale_prefix)
    end)
    |> Enum.flat_map(fn path ->
      file = File.read!(path)

      Regex.scan(~r{(:LOC_\w+)}, file)
      |> Enum.map(fn [_line, match] -> match end)
    end)
    |> Enum.uniq()
  end

  @impl true
  def run(["verify" | rest]) do
    verify =
      case rest do
        [] -> ["EN", "DE"]
        other -> other
      end

    keys = get_keys() |> MapSet.new()

    for locale <- verify do
      {:module, locale} =
        Module.concat(Util.Locale, locale)
        |> Code.ensure_compiled()

      locale_keys =
        locale.get_localization()
        |> Map.keys()
        |> MapSet.new(&inspect/1)

      missing = MapSet.difference(keys, locale_keys)

      case MapSet.to_list(missing) do
        [] -> Mix.shell().info("All keys present for #{locale} ")
        missing -> Mix.shell().error("Missing locale keys for #{locale}: #{inspect(missing)}")
      end
    end
  end

  def run([lang, friendly_name, out_file]) do
    groups =
      get_keys()
      |> Enum.group_by(
        fn key ->
          [_, key] = Regex.run(~r{^:LOC_([^_]+)}, key)
          String.downcase(key)
        end,
        fn ":" <> value -> value end
      )

    others = Enum.map_join(groups, "\n", &map_entries/1)

    content =
      @file_template
      |> String.replace("{{lang}}", String.upcase(lang))
      |> String.replace("{{friendly_name}}", friendly_name)
      |> String.replace("{{others}}", others)
      |> String.replace("{{localization}}", "%{}")
      |> String.replace("{{merges}}", Enum.map_join(groups, "                ", &map_merge/1))

    File.write!(out_file, content)
  end

  defp map_entries({name, entries}) do
    @other_template
    |> String.replace("{{name}}", name)
    |> String.replace("{{entries}}", Enum.map_join(entries, ",\n    ", &map_entry/1))
  end

  defp map_entry(entry) do
    ~s/#{entry}: "TODO"/
  end

  defp map_merge({name, _entries}) do
    @merge_template
    |> String.replace("{{name}}", name)
  end
end
