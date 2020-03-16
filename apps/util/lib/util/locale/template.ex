defmodule Util.Locale.Template do
  @templates %{
    AVATAR_DESCRIPTION: [],
    AVATAR_USAGES: [],
    AVATAR_EXAMPLES: [],
    BLACKLIST_DESCRIPTION: [],
    BLACKLIST_USAGES: [],
    BLACKLIST_EXAMPLES: [],
    BLACKLIST_BOT: [],
    BLACKLIST_SELF: [],
    BLACKLIST_PRIVILIGED: [],
    BLACKLIST_BLACKLISTED: [:user],
    BLACKLIST_NOT_BLACKLISTED: [:user],
    BLACKLIST_UNBLACKLISTED: [:user],
    BLACKLIST_EMBED_TITLE: [],
    BLACKLIST_NOBODY_BLACKLISTED: [],
    CONFIG_DESCRIPTION: [],
    CONFIG_DESCRIPTION_LONG: [],
    CONFIG_USAGES: [],
    CONFIG_EXAMPLES: [],
    CONFIG_INVALID_ACTION: [:action],
    CONFIG_INVALID_KEY: [:keys],
    CONFIG_MISSING_VALUE: [:key],
    CONFIG_PUT_VALUE: [:key],
    CONFIG_VALUE: [:key, :value],
    CONFIG_NO_VALUE: [:key],
    CONFIG_DELETED: [:key],
    CONFIG_PREFIX_LENGTH: [:limit],
    CONFIG_LOCALE_UNKNOWN: [:locales],
    CONFIG_NO_CHANNEL: [],
    CONFIGSTATUS_DESCRIPTION: [],
    CONFIGSTATUS_USAGES: [],
    CONFIGSTATUS_EXAMPLES: [],
    CONFIGSTATUS_RESPONSE: [:config],
    COMMAND_DISABLED: [],
    CONNECTED_BOT_NOT_CONNECTED: [],
    CONNECTED_USER_NOT_CONNECTED: [],
    CONNECTED_SUMMON_NOT_CONNECTED: [],
    CONNECTED_SUMMON_SAME_CHANNEL: [],
    CONNECTED_DIFFERENT_CHANNELS: [],
    DJ_CHANNEL: [:channel],
    DJ_ROLE: [:role],
    EVAL_DESCRIPTION: [],
    EVAL_USAGES: [],
    EVAL_EXAMPLES: [],
    FETCHGUILD_UNCACHED: [],
    FETCHMEMBER_FAILED: [],
    GENERIC_NO_ARGS: [],
    GENERIC_NO_USER: [:user],
    HASPERMISSIONS_SELF_MISSING_PERMISSIONS: [:permissions],
    HASPERMISSIONS_MEMBER_MISSING_PERMISSIONS: [:permissions],
    HELP_DESCRIPTION: [],
    HELP_USAGES: [],
    HELP_EXAMPLES: [],
    HELP_OVERVIEW_ENTRY: [:name, :description],
    HELP_OVERVIEW_GROUP: [:group, :entries],
    HELP_OVERVIEW: [:groups],
    HELP_NAME: [:name],
    HELP_NAME_ALIASES: [:name, :aliases],
    HELP_DETAILED: [:name, :description, :usages, :examples],
    HELP_UNKNOWN_COMMAND: [],
    INFO_DESCRIPTION: [],
    INFO_USAGES: [],
    INFO_EXAMPLES: [],
    INVITE_DESCRIPTION: [],
    INVITE_USAGES: [],
    INVITE_EXAMPLES: [],
    INVITE: [],
    INVITE_EMBED_DESCRIPTION: [:url],
    LEAVE_LEFT: [],
    LOCALE_DESCRIPTION: [],
    LOCALE_USAGES: [],
    LOCALE_EXAMPLES: [],
    LOOP_DESCRIPTION: [],
    LOOP_USAGES: [],
    LOOP_EXAMPLES: [],
    LOOP_ENABLED: [],
    LOOP_DISABLED: [],
    LOOP_INVALID_STATE: [],
    LOOP_UPDATED: [],
    LOOP_ALREADY: [],
    MUSIC_DISABLED: [],
    NOWPLAYING_DESCRIPTION: [],
    NOWPLAYING_USAGES: [],
    NOWPLAYING_EXAMPLES: [],
    OWNERONLY: [],
    PAUSE_DESCRIPTION: [],
    PAUSE_USAGES: [],
    PAUSE_EXAMPLES: [],
    PAUSE_PAUSED: [],
    PAUSE_ALREADY: [],
    PING_DESCRIPTION: [],
    PING_USAGES: [],
    PING_EXAMPLES: [],
    PING_PONG: [],
    PING_TIME: [:ping],
    PLAY_DESCRIPTION: [],
    PLAY_USAGES: [],
    PLAY_EXAMPLES: [],
    PLAY_NOTHING_FOUND: [],
    PLAY_START: [],
    PREFIX_DESCRIPTION: [],
    PREFIX_USAGES: [],
    PREFIX_EXAMPLES: [],
    QUEUE_DESCRIPTION: [],
    QUEUE_USAGES: [],
    QUEUE_EXAMPLES: [],
    QUEUE_LESS_THAN_ONE: [],
    QUEUE_NAN: [],
    QUEUE_EMBED_TITLE: [:queue_length, :queue_time],
    QUEUE_PAGES: [:page, :max_page],
    QUEUE_EMBED_DESCRIPTION: [:current, :queue],
    REMOVE_DESCRIPTION: [],
    REMOVE_USAGES: [],
    REMOVE_EXAMPLES: [],
    REMOVE_POSITION_NAN: [],
    REMOVE_COUNT_NAN: [],
    REMOVE_POSITION_NEGATIVE: [],
    REMOVE_COUNT_SMALLER_ONE: [],
    REMOVE_POSITION_OUT_OF_BOUNDS: [],
    REMOVE_REMOVED: [:count],
    RESUME_DESCRIPTION: [],
    RESUME_USAGES: [],
    RESUME_EXAMPLES: [],
    RESUME_RESUMED: [],
    RESUME_ALREADY: [],
    SAVE_DESCRIPTION: [],
    SAVE_USAGES: [],
    SAVE_EXAMPLES: [],
    SEEK_DESCRIPTION: [],
    SEEK_USAGES: [],
    SEEK_EXAMPLES: [],
    SEEK_SEEKING: [],
    SEEK_EMPTY: [],
    SEEK_NOT_SEEKABLE: [],
    SEEK_OUT_OF_BOUNDS: [],
    SEEK_NAN: [],
    SHUFFLE_DESCRIPTION: [],
    SHUFFLE_USAGES: [],
    SHUFFLE_EXAMPLES: [],
    SHUFFLE_SHUFFLED: [],
    SKIP_DESCRIPTION: [],
    SKIP_USAGES: [],
    SKIP_EXAMPLES: [],
    SKIP_LESS_THAN_ONE: [],
    SKIP_NAN: [],
    SKIP_SKIPPED: [:count],
    STOP_DESCRIPTION: [],
    STOP_USAGES: [],
    STOP_EXAMPLES: [],
    SUMMON_DESCRIPTION: [],
    SUMMON_USAGES: [],
    SUMMON_EXAMPLES: [],
    SUMMON_SUMMONED: [],
    TRACK_LOOP: [:rest],
    TRACK_POSITION: [:uri, :position, :length],
    TRACK_INFO: [:uri, :length],
    TRACK_LENGTH_DAYS: [:days, :rest],
    TRACK_DESCRIPTION: [:prefix, :info],
    TRACK_SAVE: [],
    TRACK_PLAY: [],
    TRACK_ADD: [],
    TRACK_NOW_PLAYING: [],
    TRACK_END: [],
    TRACK_PAUSE: [],
    UPTIME_DESCRIPTION: [],
    UPTIME_USAGES: [],
    UPTIME_EXAMPLES: [],
    UPTIME: [:content],
    VOICELOG_JOINED: [:user, :new_channel],
    VOICELOG_LEFT: [:user, :old_channel],
    VOICELOG_MOVED: [:user, :old_channel, :new_channel],
    VOLUME_DESCRIPTION: [],
    VOLUME_USAGES: [],
    VOLUME_EXAMPLES: [],
    VOLUME_CURRENT: [:volume],
    VOLUME_SET: [:volume],
    VOLUME_NAN: [],
    VOLUME_OUT_OF_BOUNDS: []
  }

  for {key, args} <- @templates do
    name =
      key
      |> to_string()
      |> String.downcase()
      |> String.to_atom()

    # Variables intead of literals so the parameter keep their names
    arg_list = Enum.map(args, &Macro.var(&1, Elixir))
    # The return values, tuples of variable name and variable value

    arg_tuples =
      Enum.map(
        args,
        &{&1,
         quote do
           if to_string?(unquote(Macro.var(&1, Elixir))) do
             to_string(unquote(Macro.var(&1, Elixir)))
           else
             unquote(Macro.var(&1, Elixir))
           end
         end}
      )

    def unquote(name)(unquote_splicing(arg_list)) do
      {unquote(key), unquote(arg_tuples)}
    end
  end

  defp to_string?({atom, list})
       when is_atom(atom) and is_list(list) do
    false
  end

  defp to_string?(list) when is_list(list) do
    false
  end

  defp to_string?(_other), do: true

  def verify(locale) do
    localization = locale.get_localization()

    localize_keys =
      localization
      |> Map.keys()
      |> MapSet.new()

    template_keys =
      @templates
      |> Map.keys()
      |> MapSet.new()

    unless MapSet.subset?(localize_keys, template_keys) do
      diff =
        template_keys
        |> MapSet.difference(localize_keys)
        |> MapSet.to_list()

      raise "Missing keys in #{locale}: #{inspect(diff)}"
    end

    for {key, expected_args} <- @templates do
      expected_args =
        expected_args
        |> Enum.map(&to_string/1)
        |> MapSet.new()

      string = Map.fetch!(localization, key)

      args =
        ~r/\{\{(.+?)\}\}/
        |> Regex.scan(string, capture: :all_but_first)
        |> List.flatten()
        |> MapSet.new()

      unless MapSet.equal?(args, expected_args) do
        raise """
        Mismatch in localization args

        Key: #{key}

        Expected args: #{expected_args |> MapSet.to_list()}

        Got args: #{args |> MapSet.to_list()}
        """
      end
    end

    :ok
  end
end
