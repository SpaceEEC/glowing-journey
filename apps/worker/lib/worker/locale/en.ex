defmodule Worker.Locale.EN do
  @behaviour Worker.Locale

  def code(), do: "EN"
  def friendly_name(), do: "English (English)"

  @blacklist %{
    LOC_BLACKLIST_DESCRIPTION: "Blacklist or unblacklist a user or guild.",
    LOC_BLACKLIST_USAGES: """
    **Usages**:
    - `blacklist` (get all)
    - `blacklist [UserID|GuildID]` (blacklist)
    - `blacklist remove [UserID|GuilID]` (unblacklist)
    """,
    LOC_BLACKLIST_EXAMPLES: """
    **Examples**:
    - `blacklist` (get all)
    - `blacklist 218348062828003328` (blacklist)
    - `blacklist remove 218348062828003328` (unblacklist)
    """
  }

  @config %{
    LOC_CONFIG_DESCRIPTION: """
    Set, get, or delete a configuration entry of the current server.
    """,
    LOC_CONFIG_DESCRIPTION_LONG: """
    Set, get, or delete a configuration entry of the current server.

    Currently supported keys are: `#{
      Worker.Config.Guild.get_keys() |> Enum.map_join("`, `", &String.replace(&1, "_", ""))
    }`
    """,
    LOC_CONFIG_USAGES: """
    **Usages**:
    - `config set <Key> <...Value>`
    - `config get <Key>`
    - `config delete <Key>`
    """,
    LOC_CONFIG_EXAMPLES: """
    **Examples**:
    - `config set prefix c!`
    - `config get prefix`
    - `config delete prefix`
    """,
    LOC_CONFIG_INVALID_ACTION: "``{{action}}`` is not a valid action.",
    LOC_CONFIG_INVALID_KEY: "The provided key is not valid.",
    LOC_CONFIG_MISSING_VALUE: """
    You need to provide a new value for ``{{key}}``.
    If you meant to delete, use the `delete` action instead of `set`.
    """,
    LOC_CONFIG_PUT_VALUE: "Set the new value for `{{key}}`.",
    LOC_CONFIG_VALUE: "The configured value for `{{key}}` is: {{value}}",
    LOC_CONFIG_NO_VALUE: "No configuration for `{{key}}` present.",
    LOC_CONFIG_DELETED: "Deleted the `{{key}}` configuration.",
    LOC_CONFIG_PREFIX_LENGTH: """
    I fear that prefix is too long, it must be less than {{limit}} chars long.
    """,
    LOC_CONFIG_LOCALE_UNKNOWN: """
    I fear that this locale is not supported, try one of the following:
    {{locales}}
    """,
    LOC_CONFIG_NO_CHANNEL: """
    I fear that this does not look like a valid channel mention or id to me.
    """
  }

  @configstatus %{
    LOC_CONFIGSTATUS_DESCRIPTION: """
    Display the status of the configuration for the current server.
    """,
    LOC_CONFIGSTATUS_USAGES: "**Usage**: `config-status`",
    LOC_CONFIGSTATUS_EXAMPLES: "**Example**: `config-status`",
    LOC_CONFIGSTATUS_RESPONSE: """
    An overview of the current configuration:
    ```asciidoc
    {{config}}
    ```
    Refer to the ``config`` command in order to adjust it.
    """
  }

  @connected %{
    LOC_CONNECTED_BOT_NOT_CONNECTED: """
    This commend requires me to be connected to a voice channnel and I fear I am not.
    """,
    LOC_CONNECTED_USER_NOT_CONNECTED: """
    This command requires you to be connected to a voice channel and I fear you are not.
    """,
    LOC_CONNECTED_SUMMON_NOT_CONNECTED: """
    This command requires me to be connect to a voice channel and fear I am not.
    Maybe you intended to use the `play` command instead?
    """,
    LOC_CONNECTED_SUMMON_SAME_CHANNEL: """
    I fear that you can't summon me when we are already in the same channel.
    """,
    LOC_CONNECTED_DIFFERENT_CHANNELS: """
    This command requires us both to be in the same voice channel and I fear we are not.
    """
  }

  @dj %{
    LOC_DJ_CHANNEL: "This command may only be used in the dj channel: {{channel}}.",
    LOC_DJ_ROLE: "This command may only be used by members of the dj role: {{role}}."
  }

  @eval %{
    LOC_EVAL_DESCRIPTION: "Evaluate arbitrary code snippets.",
    LOC_EVAL_USAGES: "**Usage**: `eval [...code]`",
    LOC_EVAL_EXAMPLES: "**Example**: `eval 2 = 1 + 1`"
  }

  @fetchguild %{
    LOC_FETCHGUILD_UNCACHED: """
    This server could not be found in the cache. This should never happen.
    """
  }

  @fetchmember %{
    LOC_FETCHMEMBER_FAILED: "Could not fetch the member. This should not happen."
  }

  @generic %{
    LOC_GENERIC_NO_ARGS: """
    This command requires you to provide arguments and I fear I can not find any in your message.
    """
  }

  @haspermissions %{
    LOC_HASPERMISSIONS_SELF_MISSING_PERMISSIONS: """
    I fear I do not have enough permissions to use this command.
    I am missing:
    {{permissions}}
    """,
    LOC_HASPERMISSIONS_MEMBER_MISSING_PERMISSIONS: """
    I fear you do not have enough permissions to use this command.
    You are missing:
    {{permissions}}
    """
  }

  @help %{
    LOC_HELP_DESCRIPTION: "Show an overview of commands or help for a specific command.",
    LOC_HELP_USAGES: """
    **Usages**:
    - `help`
    - `help [command]`
    """,
    LOC_HELP_EXAMPLES: """
    **Examples**:
    - `help`
    - `help help`
    """,
    LOC_HELP_OVERVIEW_ENTRY: """
    ``{{name}}`` - {{description}}
    """,
    LOC_HELP_OVERVIEW_GROUP: """
    > **{{group}}**
    {{entries}}
    """,
    LOC_HELP_OVERVIEW: """
    **Available Commands**:
     {{groups}}
    """,
    LOC_HELP_NAME: "**{{name}}**",
    LOC_HELP_NAME_ALIASES: "**{{name}}** a.k.a. ``{{aliases}}``",
    LOC_HELP_DETAILED: """
    {{name}}
    {{description}}

    > {{usages}}

    > {{examples}}
    """,
    LOC_HELP_UNKNOWN_COMMAND: "I am not aware of such a command."
  }

  @info %{
    LOC_INFO_DESCRIPTION: "Display general info about the bot.",
    LOC_INFO_USAGES: "**Usage**: `info`",
    LOC_INFO_EXAMPLES: "**Example**: `info`"
  }

  @invite %{
    LOC_INVITE_DESCRIPTION: "Invite the bot to your server.",
    LOC_INVITE_USAGES: "**Usage**: `invite`",
    LOC_INVITE_EXAMPLES: "**Example**: `invite`",
    LOC_INVITE: "Invite",
    LOC_INVITE_EMBED_DESCRIPTION: """
    To invite me to your server click [this]({{url}}) link.
    **Note**: You need the **Manage Server** permission to add me there.
    \u200b
    """
  }

  @leave %{
    LOC_LEAVE_LEFT: "Stopped playback and left your channel."
  }

  @locale %{
    LOC_LOCALE_DESCRIPTION: "Set or get the locale for the current server.",
    LOC_LOCALE_USAGES: """
    **Usages**:
    - get `locale`
    - set `locale [locale]`
    """,
    LOC_LOCALE_EXAMPLES: """
    **Examples**:
    - get `locale`
    - set `locale EN`
    """
  }

  @loop %{
    LOC_LOOP_DESCRIPTION: "Shows, enables, or disables the loop status for the current playback.",
    LOC_LOOP_USAGES: "**Usage**: `loop [NewState]`",
    LOC_LOOP_EXAMPLES: """
    **Examples**:
    - `loop` (display)
    - `loop y`
    - `loop enable`
    - `loop n`
    - `loop disable`
    """,
    LOC_LOOP_ENABLED: "The loop is currently **enabled**.",
    LOC_LOOP_DISABLED: "The loop is currently **disabled**.",
    LOC_LOOP_INVALID_STATE: """
    I could not interpret that as a new loop state, check `help loop` for examples.
    """,
    LOC_LOOP_UPDATED: "Successfully set the new loop state.",
    LOC_LOOP_ALREADY: "This is the current loop state."
  }

  @nowplaying %{
    LOC_NOWPLAYING_DESCRIPTION: "Display the currently played track",
    LOC_NOWPLAYING_USAGES: "**Usage**: `nowplaying`",
    LOC_NOWPLAYING_EXAMPLES: "**Example**: `nowplaying`"
  }

  @owneronly %{
    LOC_OWNERONLY: "This command requires you to be a bot owner and I fear you are not."
  }

  @pause %{
    LOC_PAUSE_DESCRIPTION: "Pause the playback.",
    LOC_PAUSE_USAGES: "**Usage**: `pause`",
    LOC_PAUSE_EXAMPLES: "**Example**: `pause`",
    LOC_PAUSE_PAUSED: "Paused the playback.",
    LOC_PAUSE_ALREADY: "I fear the playback is already paused."
  }

  @ping %{
    LOC_PING_DESCRIPTION: "Pong!",
    LOC_PING_USAGES: "**Usage**: `ping`",
    LOC_PING_EXAMPLES: "**Example**: `ping`",
    LOC_PING_PONG: "Pong!"
  }

  @play %{
    LOC_PLAY_DESCRIPTION: """
    Play a track or a playlist via a video / playlist url or search query.
    """,
    LOC_PLAY_USAGES: """
    **Usages**:
    - `play <...Search>`
    - `play <Video-URL>`
    - `play <Playlist-URL>`
    """,
    LOC_PLAY_EXAMPLES: """
    **Examples**:
    - `play harito geist`
    - `play https://www.youtube.com/watch?v=xbx_t3YA9qQ`
    - `play https://www.youtube.com/playlist?list=PLLAAisT6WX23GeuJ44f0OLWAIygqQopck`
    """,
    LOC_PLAY_NOTHING_FOUND: "I fear I could not find any results.",
    LOC_PLAY_START: "Starting playback..."
  }

  @prefix %{
    LOC_PREFIX_DESCRIPTION: "Set or get the prefix for the current server.",
    LOC_PREFIX_USAGES: """
    **Usages**:
    - get `prefix`
    - set `prefix [prefix]`
    """,
    LOC_PREFIX_EXAMPLES: """
    **Examples**:
    - get `prefix`
    - set `prefix c!`
    """
  }

  @queue %{
    LOC_QUEUE_DESCRIPTION: "Display the queue.",
    LOC_QUEUE_USAGES: "**Usage**: `queue [Page]`",
    LOC_QUEUE_EXAMPLES: """
    **Examples**:
    - `queue`
    - `queue 2`
    """,
    LOC_QUEUE_LESS_THAN_ONE: "Queue pages start at 1.",
    LOC_QUEUE_NAN: "I could not interpret that as a number.",
    LOC_QUEUE_EMBED_TITLE: "Queued up tracks: {{queue_length}} | Queue length: {{queue_time}}",
    LOC_QUEUE_PAGES: "Page {{page}} of {{max_page}}",
    LOC_QUEUE_EMBED_DESCRIPTION: """
    {{current}}

    Queue:
    {{queue}}
    """
  }

  @remove %{
    LOC_REMOVE_DESCRIPTION: "Removes one or more tracks at the given position.",
    LOC_REMOVE_USAGES: "**Usage**: `remove <Position> [Count]",
    LOC_REMOVE_EXAMPLES: """
    **Examples**:
    - `remove 1` (same as `skip`)
    - `remove 2` (removes the first track in the queue)
    - `remove 2 1` (same as above)
    - `remove 2 2` (removes the first two tracks in the queue)
    """,
    LOC_REMOVE_POSITION_NAN: "I fear that the provided position is not a number.",
    LOC_REMOVE_COUNT_NAN: "I fear that the provided count is not a number.",
    LOC_REMOVE_POSITION_NEGATIVE: """
    I fear that the provided position is negative, it must be positive.
    """,
    LOC_REMOVE_COUNT_SMALLER_ONE: """
    I fear that the provided count is smaller than one, it must be larger.
    """,
    LOC_REMOVE_POSITION_OUT_OF_BOUNDS: "I fear that the provided position is out of bounds.",
    LOC_REMOVE_REMOVED: "Removed {{count}} track(s)."
  }

  @resume %{
    LOC_RESUME_DESCRIPTION: "Resume the playback.",
    LOC_RESUME_USAGES: "**Usage**: `resume`",
    LOC_RESUME_EXAMPLES: "**Example**: `resume`",
    LOC_RESUME_RESUMED: "Resumed the playback.",
    LOC_RESUME_ALREADY: "I fear there is nothing to resume."
  }

  @save %{
    LOC_SAVE_DESCRIPTION: "Send the currently played track to your dms.",
    LOC_SAVE_USAGES: "**Usage**: `save`",
    LOC_SAVE_EXAMPLES: "**Example**: `save`"
  }

  @shuffle %{
    LOC_SHUFFLE_DESCRIPTION: "Shuffle the queue.",
    LOC_SHUFFLE_USAGES: "**Usage**: `shuffle`",
    LOC_SHUFFLE_EXAMPLES: "**Example**: `shuffle`",
    LOC_SHUFFLE_SHUFFLED: "Successfully shuffled the queue."
  }

  @skip %{
    LOC_SKIP_DESCRIPTION: "Skip one or multiple tracks.",
    LOC_SKIP_USAGES: "**Usage**: `skip [Count]`",
    LOC_SKIP_EXAMPLES: """
    **Examples**:
    - `skip` (skips one)
    - `skip 1`
    - `skip 5`
    """,
    LOC_SKIP_LESS_THAN_ONE: "I fear that it is not possible to skip less zero or less tracks.",
    LOC_SKIP_NAN: "I fear that that is not a number.",
    LOC_SKIP_SKIPPED: "Skipped {{count}} track(s)."
  }

  @stop %{
    LOC_STOP_DESCRIPTION: "Stops the playback and leaves the channel.",
    LOC_STOP_USAGES: "**Usage**: `stop`",
    LOC_STOP_EXAMPLES: "**Example**: `stop`"
  }

  @summon %{
    LOC_SUMMON_DESCRIPTION: "Summon me from another to your voice channel.",
    LOC_SUMMON_USAGES: "**Usage**: `summon`",
    LOC_SUMMON_EXAMPLES: "**Example**: `summon`",
    LOC_SUMMON_SUMMONED: "Joining your channel..."
  }

  @track %{
    LOC_TRACK_LOOP: """
    **Loop is enabled**
    {{rest}}
    """,
    LOC_TRACK_POSITION: """
    {{uri}}
    Time: (`{{position}}` / `{{length}}`)
    """,
    LOC_TRACK_INFO: """
    {{uri}}
    Length: {{length}}
    """,
    LOC_TRACK_LENGTH_DAYS: "{{days}} days {{rest}}",
    LOC_TRACK_DESCRIPTION: "{{prefix}} {{info}}",
    LOC_TRACK_SAVE: "saved, just for you",
    LOC_TRACK_PLAY: "is now being played",
    LOC_TRACK_ADD: "has been added",
    LOC_TRACK_NOW_PLAYING: "currently playing",
    LOC_TRACK_END: "has enbed",
    LOC_TRACK_PAUSE: "is paused"
  }

  @uptime %{
    LOC_UPTIME_DESCRIPTION: "Display the uptime of the bot.",
    LOC_UPTIME_USAGES: "**Usage**: `uptime`",
    LOC_UPTIME_EXAMPLES: "**Example**: `uptime`",
    LOC_UPTIME: """
    **Uptime:**
    ```asciidoc
    {{content}}
    ```
    """
  }

  @localization %{}
                |> Map.merge(@blacklist, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@config, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@configstatus, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@connected, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@dj, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@eval, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@fetchguild, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@fetchmember, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@generic, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@haspermissions, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@help, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@info, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@invite, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@leave, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@locale, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@loop, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@nowplaying, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@owneronly, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@pause, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@ping, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@play, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@prefix, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@queue, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@remove, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@resume, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@save, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@shuffle, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@skip, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@stop, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@summon, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@track, &Worker.Locale.raise_duplicate_key/3)
                |> Map.merge(@uptime, &Worker.Locale.raise_duplicate_key/3)

  @spec get_string(atom()) :: String.t() | no_return()
  def get_string(key) do
    Map.get_lazy(@localization, key, fn ->
      require Logger
      message = "Missing locale key #{key}!"

      Logger.error(fn -> message end)

      "ERROR: " <> message
    end)
  end
end
