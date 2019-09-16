defmodule Worker.Command.Config do
  use Worker.Command

  alias Worker.Resolver
  alias Util.Config.Guild
  alias Util.Locale

  @actions ~w(set get delete)
  @friendly_to_internal Guild.get_keys()
                        |> Map.new(&{String.replace(&1, "_", ""), &1})
  @keys @friendly_to_internal |> Map.keys()
  @string_keys Guild.string_keys()
  @channel_keys Guild.channel_keys()
  @role_keys Guild.role_keys()

  @impl true
  def description(long_or_short \\ :short)
  def description(:short), do: Template.config_description()
  def description(:long), do: Template.config_description_long()

  @impl true
  def usages(), do: Template.config_usages()

  @impl true
  def examples(), do: Template.config_examples()

  @impl true
  def triggers(), do: ["config", "conf"]
  @impl true
  def required() do
    [MiddleWare.GuildOnly, {MiddleWare.HasPermissions, {:manage_guild, nil, :member}}]
  end

  @impl true
  def call(%{args: []} = command, _) do
    set_response(command, content: Template.generic_no_args())
  end

  # allow reversed key and action commands, because that will happen and is easy to handle
  def call(%{args: [key, action | rest]} = command, opts)
      when key in @keys and action in @actions do
    call(%{command | args: [action, key | rest]}, opts)
  end

  def call(%{args: [not_action | _args]} = command, _)
      when not_action not in @actions do
    set_response(command, content: Template.config_invalid_action(not_action))
  end

  def call(%{args: [action, key | rest]} = command, _) do
    if String.downcase(key) not in @keys do
      set_response(command, content: Template.config_invalid_key(Enum.join(@keys, " ")))
    else
      fun = String.to_existing_atom(action)

      apply(__MODULE__, fun, [command, key, Enum.join(rest, " ")])
    end
  end

  def set(command, key, "") do
    set_response(command, content: Template.config_missing_value(key))
  end

  def set(%{message: %{guild_id: guild_id}} = command, key, value) do
    internal_key = Map.fetch!(@friendly_to_internal, key)

    case transform_value(command, internal_key, value) do
      {:ok, value} ->
        fun = String.to_existing_atom("put_#{internal_key}")
        :ok = apply(Guild, fun, [guild_id, value])

        set_response(command, content: Template.config_put_value(key))

      {:error, other} ->
        set_response(command, content: other)
    end
  end

  def get(%{message: %{guild_id: guild_id}} = command, key, _) do
    fun = String.to_existing_atom("get_#{Map.fetch!(@friendly_to_internal, key)}")
    value = apply(Guild, fun, [guild_id])

    content =
      cond do
        value ->
          Template.config_value(key, value)

        key == "prefix" ->
          Template.config_value(key, Worker.Commands.get_default_prefix())

        key == "locale" ->
          value =
            nil
            |> Locale.fetch!()
            |> Module.split()
            |> List.last()
            |> to_string()

          Template.config_value(key, value)

        true ->
          Template.config_no_value(key)
      end

    set_response(command, content: content)
  end

  def delete(%{message: %{guild_id: guild_id}} = command, key, _) do
    fun = String.to_existing_atom("delete_#{Map.fetch!(@friendly_to_internal, key)}")
    deleted = apply(Guild, fun, [guild_id])

    if deleted > 0 do
      set_response(command, content: Template.config_deleted(key))
    else
      set_response(command, content: Template.config_no_value(key))
    end
  end

  defp transform_value(_command, internal_key, value)
       when internal_key in @string_keys do
    {:ok, value}
  end

  defp transform_value(_command, "prefix", value) do
    limit = 32

    if String.length(value) < limit do
      {:ok, value}
    else
      {:error, Template.config_prefix_length(limit)}
    end
  end

  defp transform_value(_command, "locale", value) do
    names = Locale.get_names()

    if Map.has_key?(names, String.upcase(value)) do
      {:ok, String.upcase(value)}
    else
      names = Enum.map_join(names, "\n", fn {code, name} -> "#{code} - #{name}" end)
      {:error, Template.config_locale_unknown(names)}
    end
  end

  defp transform_value(_command, "volume", value) do
    case Integer.parse(value) do
      {value, ""} when value in 0..1000 ->
        {:ok, to_string(value)}

      {_other, ""} ->
        {:error, Template.volume_out_of_bounds()}

      _other ->
        {:error, Template.volume_nan()}
    end
  end

  defp transform_value(command, internal_key, value)
       when internal_key in @channel_keys do
    case Resolver.Channel.resolve(
           value,
           0,
           Cache.fetch!(:"Elixir.Guild", command.message.guild_id)
         ) do
      nil ->
        {:error, Template.config_no_channel()}

      channel ->
        {:ok, to_string(channel.id)}
    end
  end

  defp transform_value(command, internal_key, value)
       when internal_key in @role_keys do
    case Resolver.Role.resolve(
           value,
           false,
           Cache.fetch!(:"Elixir.Guild", command.message.guild_id)
         ) do
      nil ->
        {:error, Template.config_no_channel()}

      role ->
        {:ok, to_string(role.id)}
    end
  end
end
