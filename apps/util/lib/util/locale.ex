defmodule Util.Locale do
  @moduledoc """
    Module handling the localization of strings.
  """

  alias Util.Config.Guild

  @locales [
    Util.Locale.DE,
    Util.Locale.EN
  ]

  defp default(), do: Application.fetch_env!(:util, :default_locale)

  @typedoc """
    Module implementing the `Util.Locale` behavior.
  """
  @type locale :: module()

  @typedoc """
    Something that can be localized.

    A string will be returned as-is.
  """
  @type localizable :: atom() | {atom(), [{atom(), String.t()}]} | String.t()

  @doc """
    Returns the locale code.
  """
  @callback code() :: String.t()

  @doc """
    Returns the friendly name of the locale.
  """
  @callback friendly_name() :: String.t()

  @doc """
    Returns the translated string (template) for the given resource atom.
  """
  @callback get_string(atom()) :: String.t()

  @doc """
    Returns the internal localization map.
  """
  @callback get_localization() :: %{atom() => String.t()}

  ### End behavior

  @doc """
    Helper being used to raise a helpful error if a duplicated locale key was detected.
  """
  def raise_duplicate_key(key, _value1, _value2) do
    raise "Duplicated locale key #{key}!"
  end

  @doc """
    Whether something is localizable
  """
  defguard is_localizable(x) when is_atom(x) or (is_tuple(x) and tuple_size(x) == 2)

  @doc """
    Gets all friendly names keyed by language code.
  """
  @spec get_names() :: %{String.t() => String.t()}
  def get_names(), do: Map.new(@locales, &{&1.code(), &1.friendly_name()})

  @doc """
    Fetches the locale of a guild by id or message.
  """
  @spec fetch!(Crux.Structs.Message.t() | Crux.Rest.snowflake()) :: locale()
  def fetch!(%{guild_id: guild_id}), do: fetch!(guild_id)
  def fetch!(nil), do: default()

  def fetch!(guild_id) do
    Guild.get_locale(guild_id, nil)
    |> case do
      nil ->
        default()

      mod ->
        Module.safe_concat(Util.Locale, mod)
    end
  end

  @spec localize(locale(), localizable() | [localizable()]) :: String.t() | no_return()
  def localize(locale, {key, kw}), do: localize(locale, key, kw)

  def localize(locale, list)
      when is_list(list) do
    Enum.map_join(list, "\n", &localize(locale, &1))
  end

  @spec localize(locale(), atom() | String.t(), [{atom(), String.t()}]) ::
          String.t() | no_return()
  def localize(locale, key_or_string, kw \\ [])

  def localize(locale, key, kw)
      when is_atom(key) and is_atom(locale) do
    localize(locale, locale.get_string(key), kw)
  end

  def localize(locale, string, kw)
      when is_binary(string) do
    Enum.reduce(
      kw,
      string,
      fn {key, replacement}, string ->
        replacement =
          locale
          |> localize(replacement)
          |> String.trim()

        String.replace(string, "{{#{key}}}", replacement)
      end
    )
    |> String.trim()
  end

  @spec localize_response([{atom(), term()}] | map(), locale()) :: map()
  def localize_response(response, locale)
      when not is_map(response) and is_list(response) do
    response
    |> Map.new()
    |> localize_response(locale)
  end

  def localize_response(%{content: content} = response, locale)
      when is_localizable(content) do
    response
    |> Map.update!(:content, &localize(locale, &1))
    |> localize_response(locale)
  end

  def localize_response(%{embed: _embed} = response, locale) do
    response
    |> Map.update!(:embed, &localize_embed(&1, locale))

    # no recursion here, otherwise we would endlessly recurse
  end

  # done
  def localize_response(response, _locale), do: response

  def localize_embed(%{description: description} = embed, locale)
      when is_localizable(description) do
    embed
    |> Map.update!(:description, &localize(locale, &1))
    |> localize_embed(locale)
  end

  def localize_embed(%{title: title} = embed, locale)
      when is_localizable(title) do
    embed
    |> Map.update!(:title, &localize(locale, &1))
    |> localize_embed(locale)
  end

  def localize_embed(%{footer: %{text: text}} = embed, locale)
      when is_localizable(text) do
    embed
    |> update_in([:footer, :text], &localize(locale, &1))
    |> localize_embed(locale)
  end

  def localize_embed(%{author: %{name: name}} = embed, locale)
      when is_localizable(name) do
    embed
    |> update_in([:author, :name], &localize(locale, &1))
    |> localize_embed(locale)
  end

  def localize_embed(%{fields: _fields} = embed, locale) do
    embed
    |> Map.update!(:fields, &Enum.map(&1, fn field -> localize_field(field, locale) end))

    # no recursion here, otherwise we would endlessly recurse
  end

  # done
  def localize_embed(embed, _locale), do: embed

  defp localize_field(field, locale) do
    field
    |> Map.update!(:name, &localize_field_entry(&1, locale))
    |> Map.update!(:value, &localize_field_entry(&1, locale))
  end

  defp localize_field_entry(entry, locale)
       when is_localizable(entry) do
    localize(locale, entry)
  end

  defp localize_field_entry(entry, _locale), do: entry
end
