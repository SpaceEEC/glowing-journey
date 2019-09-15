defmodule Util.Locale.EN do
  @behaviour Util.Locale

  def code(), do: "EN"
  def friendly_name(), do: "English (English)"

  @avatar %{
    AVATAR_DESCRIPTION: "Shows the avatar of the requested user.",
    AVATAR_USAGES: "**Usage**: `avatar <User>`",
    AVATAR_EXAMPLES: """
    **Examples**:
    - `avatar 218348062828003328`
    - `avatar @space#0001`
    - `avatar space`
    """
  }

  @blacklist %{
    BLACKLIST_DESCRIPTION: "Blacklist or unblacklist a user.",
    BLACKLIST_USAGES: """
    **Usages**:
    - `blacklist` (get all)
    - `blacklist [User]` (blacklist)
    - `blacklist add [User]` (blacklist)
    - `blacklist remove [User]` (unblacklist)
    """,
    BLACKLIST_EXAMPLES: """
    **Examples**:
    - `blacklist` (get all)
    - `blacklist 218348062828003328` (blacklist)
    - `blacklist add 218348062828003328` (blacklist)
    - `blacklist remove 218348062828003328` (unblacklist)
    """,
    BLACKLIST_BOT: "Not neeed, I already ignore all bots.",
    BLACKLIST_SELF: "I don't think you want to blacklist yourself.",
    BLACKLIST_PRIVILIGED: "You may not blacklist a priviliged user.",
    BLACKLIST_BLACKLISTED: "Blacklisted {{user}} from using commands in this server.",
    BLACKLIST_NOT_BLACKLISTED: "``{{user}}`` is not blacklisted.",
    BLACKLIST_UNBLACKLISTED: "Unblacklisted {{user}} from using commands in this server.",
    BLACKLIST_EMBED_TITLE: "In this guild blacklisted:",
    BLACKLIST_NOBODY_BLACKLISTED: "Nobody"
  }

  @config %{
    CONFIG_DESCRIPTION: """
    Set, get, or delete a configuration entry of the current server.
    """,
    CONFIG_DESCRIPTION_LONG: """
    Set, get, or delete a configuration entry of the current server.

    Currently supported keys are: `#{
      Util.Config.Guild.get_keys() |> Enum.map_join("`, `", &String.replace(&1, "_", ""))
    }`
    """,
    CONFIG_USAGES: """
    **Usages**:
    - `config set <Key> <...Value>`
    - `config get <Key>`
    - `config delete <Key>`
    """,
    CONFIG_EXAMPLES: """
    **Examples**:
    - `config set prefix c!`
    - `config get prefix`
    - `config delete prefix`
    """,
    CONFIG_INVALID_ACTION: "``{{action}}`` is not a valid action.",
    CONFIG_INVALID_KEY: """
    The provided key is not valid.
    Supported keys are: ``{{keys}}``
    """,
    CONFIG_MISSING_VALUE: """
    You need to provide a new value for ``{{key}}``.
    If you meant to delete, use the `delete` action instead of `set`.
    """,
    CONFIG_PUT_VALUE: "Set the new value for `{{key}}`.",
    CONFIG_VALUE: "The configured value for `{{key}}` is: {{value}}",
    CONFIG_NO_VALUE: "No configuration for `{{key}}` present.",
    CONFIG_DELETED: "Deleted the `{{key}}` configuration.",
    CONFIG_PREFIX_LENGTH: """
    I fear that prefix is too long, it must be less than {{limit}} chars long.
    """,
    CONFIG_LOCALE_UNKNOWN: """
    I fear that this locale is not supported, try one of the following:
    {{locales}}
    """,
    CONFIG_NO_CHANNEL: """
    I fear that this does not look like a valid channel mention or id to me.
    """
  }

  @configstatus %{
    CONFIGSTATUS_DESCRIPTION: """
    Display the status of the configuration for the current server.
    """,
    CONFIGSTATUS_USAGES: "**Usage**: `config-status`",
    CONFIGSTATUS_EXAMPLES: "**Example**: `config-status`",
    CONFIGSTATUS_RESPONSE: """
    An overview of the current configuration:
    ```asciidoc
    {{config}}
    ```
    Refer to the ``config`` command in order to adjust it.
    """
  }

  @connected %{
    CONNECTED_BOT_NOT_CONNECTED: """
    This commend requires me to be connected to a voice channnel and I fear I am not.
    """,
    CONNECTED_USER_NOT_CONNECTED: """
    This command requires you to be connected to a voice channel and I fear you are not.
    """,
    CONNECTED_SUMMON_NOT_CONNECTED: """
    This command requires me to be connect to a voice channel and fear I am not.
    Maybe you intended to use the `play` command instead?
    """,
    CONNECTED_SUMMON_SAME_CHANNEL: """
    I fear that you can't summon me when we are already in the same channel.
    """,
    CONNECTED_DIFFERENT_CHANNELS: """
    This command requires us both to be in the same voice channel and I fear we are not.
    """
  }

  @dj %{
    DJ_CHANNEL: "This command may only be used in the dj channel: {{channel}}.",
    DJ_ROLE: "This command may only be used by members of the dj role: {{role}}."
  }

  @eval %{
    EVAL_DESCRIPTION: "Evaluate arbitrary code snippets.",
    EVAL_USAGES: "**Usage**: `eval [...code]`",
    EVAL_EXAMPLES: "**Example**: `eval 2 = 1 + 1`"
  }

  @fetchguild %{
    FETCHGUILD_UNCACHED: """
    This server could not be found in the cache. This should never happen.
    """
  }

  @fetchmember %{
    FETCHMEMBER_FAILED: "Could not fetch the member. This should not happen."
  }

  @generic %{
    GENERIC_NO_ARGS: """
    This command requires you to provide arguments and I fear I can not find any in your message.
    """,
    GENERIC_NO_USER: "Could not found a user with ``{{user}}``."
  }

  @haspermissions %{
    HASPERMISSIONS_SELF_MISSING_PERMISSIONS: """
    I fear I do not have enough permissions to use this command.
    I am missing:
    {{permissions}}
    """,
    HASPERMISSIONS_MEMBER_MISSING_PERMISSIONS: """
    I fear you do not have enough permissions to use this command.
    You are missing:
    {{permissions}}
    """
  }

  @help %{
    HELP_DESCRIPTION: "Show an overview of commands or help for a specific command.",
    HELP_USAGES: """
    **Usages**:
    - `help`
    - `help [command]`
    """,
    HELP_EXAMPLES: """
    **Examples**:
    - `help`
    - `help help`
    """,
    HELP_OVERVIEW_ENTRY: """
    ``{{name}}`` - {{description}}
    """,
    HELP_OVERVIEW_GROUP: """
    > **{{group}}**
    {{entries}}
    """,
    HELP_OVERVIEW: """
    **Available Commands**:
     {{groups}}
    """,
    HELP_NAME: "**{{name}}**",
    HELP_NAME_ALIASES: "**{{name}}** a.k.a. ``{{aliases}}``",
    HELP_DETAILED: """
    {{name}}
    {{description}}

    > {{usages}}

    > {{examples}}
    """,
    HELP_UNKNOWN_COMMAND: "I am not aware of such a command."
  }

  @info %{
    INFO_DESCRIPTION: "Display general info about the bot.",
    INFO_USAGES: "**Usage**: `info`",
    INFO_EXAMPLES: "**Example**: `info`"
  }

  @invite %{
    INVITE_DESCRIPTION: "Invite the bot to your server.",
    INVITE_USAGES: "**Usage**: `invite`",
    INVITE_EXAMPLES: "**Example**: `invite`",
    INVITE: "Invite",
    INVITE_EMBED_DESCRIPTION: """
    To invite me to your server click [this]({{url}}) link.
    **Note**: You need the **Manage Server** permission to add me there.
    \u200b
    """
  }

  @leave %{
    LEAVE_LEFT: "Stopped playback and left your channel."
  }

  @locale %{
    LOCALE_DESCRIPTION: "Set or get the locale for the current server.",
    LOCALE_USAGES: """
    **Usages**:
    - get `locale`
    - set `locale [locale]`
    """,
    LOCALE_EXAMPLES: """
    **Examples**:
    - get `locale`
    - set `locale EN`
    """
  }

  @loop %{
    LOOP_DESCRIPTION: "Shows, enables, or disables the loop status for the current playback.",
    LOOP_USAGES: "**Usage**: `loop [NewState]`",
    LOOP_EXAMPLES: """
    **Examples**:
    - `loop` (display)
    - `loop y`
    - `loop enable`
    - `loop n`
    - `loop disable`
    """,
    LOOP_ENABLED: "The loop is currently **enabled**.",
    LOOP_DISABLED: "The loop is currently **disabled**.",
    LOOP_INVALID_STATE: """
    I could not interpret that as a new loop state, check `help loop` for examples.
    """,
    LOOP_UPDATED: "Successfully set the new loop state.",
    LOOP_ALREADY: "This is the current loop state."
  }

  @nowplaying %{
    NOWPLAYING_DESCRIPTION: "Display the currently played track",
    NOWPLAYING_USAGES: "**Usage**: `nowplaying`",
    NOWPLAYING_EXAMPLES: "**Example**: `nowplaying`"
  }

  @owneronly %{
    OWNERONLY: "This command requires you to be a bot owner and I fear you are not."
  }

  @pause %{
    PAUSE_DESCRIPTION: "Pause the playback.",
    PAUSE_USAGES: "**Usage**: `pause`",
    PAUSE_EXAMPLES: "**Example**: `pause`",
    PAUSE_PAUSED: "Paused the playback.",
    PAUSE_ALREADY: "I fear the playback is already paused."
  }

  @ping %{
    PING_DESCRIPTION: "Pong!",
    PING_USAGES: "**Usage**: `ping`",
    PING_EXAMPLES: "**Example**: `ping`",
    PING_PONG: "Pong!",
    PING_TIME: "Pong! ({{ping}}ms)"
  }

  @play %{
    PLAY_DESCRIPTION: """
    Play a track or a playlist via a video / playlist url or search query.
    """,
    PLAY_USAGES: """
    **Usages**:
    - `play <...Search>`
    - `play <Video-URL>`
    - `play <Playlist-URL>`
    """,
    PLAY_EXAMPLES: """
    **Examples**:
    - `play harito geist`
    - `play https://www.youtube.com/watch?v=xbx_t3YA9qQ`
    - `play https://www.youtube.com/playlist?list=PLLAAisT6WX23GeuJ44f0OLWAIygqQopck`
    """,
    PLAY_NOTHING_FOUND: "I fear I could not find any results.",
    PLAY_START: "Starting playback..."
  }

  @prefix %{
    PREFIX_DESCRIPTION: "Set or get the prefix for the current server.",
    PREFIX_USAGES: """
    **Usages**:
    - get `prefix`
    - set `prefix [prefix]`
    """,
    PREFIX_EXAMPLES: """
    **Examples**:
    - get `prefix`
    - set `prefix c!`
    """
  }

  @queue %{
    QUEUE_DESCRIPTION: "Display the queue.",
    QUEUE_USAGES: "**Usage**: `queue [Page]`",
    QUEUE_EXAMPLES: """
    **Examples**:
    - `queue`
    - `queue 2`
    """,
    QUEUE_LESS_THAN_ONE: "Queue pages start at 1.",
    QUEUE_NAN: "I could not interpret that as a number.",
    QUEUE_EMBED_TITLE: "Queued up tracks: {{queue_length}} | Queue length: {{queue_time}}",
    QUEUE_PAGES: "Page {{page}} of {{max_page}}",
    QUEUE_EMBED_DESCRIPTION: """
    {{current}}

    Queue:
    {{queue}}
    """
  }

  @remove %{
    REMOVE_DESCRIPTION: "Removes one or more tracks at the given position.",
    REMOVE_USAGES: "**Usage**: `remove <Position> [Count]",
    REMOVE_EXAMPLES: """
    **Examples**:
    - `remove 1` (same as `skip`)
    - `remove 2` (removes the first track in the queue)
    - `remove 2 1` (same as above)
    - `remove 2 2` (removes the first two tracks in the queue)
    """,
    REMOVE_POSITION_NAN: "I fear that the provided position is not a number.",
    REMOVE_COUNT_NAN: "I fear that the provided count is not a number.",
    REMOVE_POSITION_NEGATIVE: """
    I fear that the provided position is negative, it must be positive.
    """,
    REMOVE_COUNT_SMALLER_ONE: """
    I fear that the provided count is smaller than one, it must be larger.
    """,
    REMOVE_POSITION_OUT_OF_BOUNDS: "I fear that the provided position is out of bounds.",
    REMOVE_REMOVED: "Removed {{count}} track(s)."
  }

  @resume %{
    RESUME_DESCRIPTION: "Resume the playback.",
    RESUME_USAGES: "**Usage**: `resume`",
    RESUME_EXAMPLES: "**Example**: `resume`",
    RESUME_RESUMED: "Resumed the playback.",
    RESUME_ALREADY: "I fear there is nothing to resume."
  }

  @save %{
    SAVE_DESCRIPTION: "Send the currently played track to your dms.",
    SAVE_USAGES: "**Usage**: `save`",
    SAVE_EXAMPLES: "**Example**: `save`"
  }

  @shuffle %{
    SHUFFLE_DESCRIPTION: "Shuffle the queue.",
    SHUFFLE_USAGES: "**Usage**: `shuffle`",
    SHUFFLE_EXAMPLES: "**Example**: `shuffle`",
    SHUFFLE_SHUFFLED: "Successfully shuffled the queue."
  }

  @skip %{
    SKIP_DESCRIPTION: "Skip one or multiple tracks.",
    SKIP_USAGES: "**Usage**: `skip [Count]`",
    SKIP_EXAMPLES: """
    **Examples**:
    - `skip` (skips one)
    - `skip 1`
    - `skip 5`
    """,
    SKIP_LESS_THAN_ONE: "I fear that it is not possible to skip less zero or less tracks.",
    SKIP_NAN: "I fear that that is not a number.",
    SKIP_SKIPPED: "Skipped {{count}} track(s)."
  }

  @stop %{
    STOP_DESCRIPTION: "Stops the playback and leaves the channel.",
    STOP_USAGES: "**Usage**: `stop`",
    STOP_EXAMPLES: "**Example**: `stop`"
  }

  @summon %{
    SUMMON_DESCRIPTION: "Summon me from another to your voice channel.",
    SUMMON_USAGES: "**Usage**: `summon`",
    SUMMON_EXAMPLES: "**Example**: `summon`",
    SUMMON_SUMMONED: "Joining your channel..."
  }

  @track %{
    TRACK_LOOP: """
    **Loop is enabled**
    {{rest}}
    """,
    TRACK_POSITION: """
    {{uri}}
    Time: (`{{position}}` / `{{length}}`)
    """,
    TRACK_INFO: """
    {{uri}}
    Length: {{length}}
    """,
    TRACK_LENGTH_DAYS: "{{days}} days {{rest}}",
    TRACK_DESCRIPTION: "{{prefix}} {{info}}",
    TRACK_SAVE: "saved, just for you",
    TRACK_PLAY: "is now being played",
    TRACK_ADD: "has been added",
    TRACK_NOW_PLAYING: "currently playing",
    TRACK_END: "has enbed",
    TRACK_PAUSE: "is paused"
  }

  @uptime %{
    UPTIME_DESCRIPTION: "Display the uptime of the bot.",
    UPTIME_USAGES: "**Usage**: `uptime`",
    UPTIME_EXAMPLES: "**Example**: `uptime`",
    UPTIME: """
    **Uptime:**
    ```asciidoc
    {{content}}
    ```
    """
  }

  @voicelog %{
    VOICELOG_JOINED: "{{user}} connected to {{new_channel}}.",
    VOICELOG_LEFT: "{{user}} disconnected from {{old_channel}}.",
    VOICELOG_MOVED: "{{user}} moved from {{old_channel}} to {{new_channel}}."
  }

  @volume %{
    VOLUME_DESCRIPTION: "Set or get the volume for the playback.",
    VOLUME_USAGES: "**Usage**: `volume [NewVolume]",
    VOLUME_EXAMPLES: """
    **Examples**:
    - `volume` (get current)
    - `volume 0` (set new)
    """,
    VOLUME_CURRENT: "The current volume is {{volume}}/1000",
    VOLUME_SET: "New volume set.",
    VOLUME_NAN: "I could not interpret the voume as a number.",
    VOLUME_OUT_OF_BOUNDS: "The volume must be at least 0 and at max 1000."
  }

  @localization %{}
                |> Map.merge(@avatar, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@blacklist, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@config, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@configstatus, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@connected, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@dj, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@eval, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@fetchguild, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@fetchmember, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@generic, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@haspermissions, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@help, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@info, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@invite, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@leave, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@locale, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@loop, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@nowplaying, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@owneronly, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@pause, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@ping, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@play, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@prefix, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@queue, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@remove, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@resume, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@save, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@shuffle, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@skip, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@stop, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@summon, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@track, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@uptime, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@voicelog, &Util.Locale.raise_duplicate_key/3)
                |> Map.merge(@volume, &Util.Locale.raise_duplicate_key/3)

  def get_localization() do
    @localization
  end

  @spec get_string(atom()) :: String.t() | no_return()
  def get_string(key) do
    Map.get_lazy(@localization, key, fn ->
      message = "Missing locale key #{key}!"

      require Rpc.Sentry
      Rpc.Sentry.error(message, "locale")
      Sentry.capture_message("Missing locale key.")

      "ERROR: " <> message
    end)
  end
end
