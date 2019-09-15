defmodule Util.Locale.DE do
  @behaviour Util.Locale

  def code(), do: "DE"
  def friendly_name(), do: "German (Deutsch)"

  @avatar %{
    AVATAR_DESCRIPTION: "Zeigt das Avatar des gewünschten Nutzers an.",
    AVATAR_USAGES: "**Anwendung**: `avatar <User>`",
    AVATAR_EXAMPLES: """
    **Beispiele**:
    - `avatar 218348062828003328`
    - `avatar @space#0001`
    - `avatar space`
    """,
  }

  @blacklist %{
    BLACKLIST_DESCRIPTION: "Blackliste einen Nutzer auf diesem Server oder hebe diesen auf.",
    BLACKLIST_USAGES: """
    **Anwendungen**:
    - `blacklist`
    - `blacklist [User]`
    - `blacklist add [User]`
    - `blacklist remove [User]`
    """,
    BLACKLIST_EXAMPLES: """
    **Beispiele**:
    - `blacklist`
    - `blacklist 218348062828003328`
    - `blacklist add 218348062828003328`
    - `blacklist remove 218348062828003328`
    """,
    BLACKLIST_BOT: "Nicht nötig, ich ignoriere bereits sämtliche Bots.",
    BLACKLIST_SELF: "Sich selbst auf die Blacklist schreiben? Ich denke nicht.",
    BLACKLIST_PRIVILIGED: """
    Privilegierte Nutzer können nicht auf die Blacklist geschrieben werden.
    """,
    BLACKLIST_BLACKLISTED: """
    ``{{user}}`` befindet sich von nun an auf der Blacklist und kann auf diesem Server keinerlei Befehle mehr verwenden.
    """,
    BLACKLIST_NOT_BLACKLISTED: "``{{user}}`` befindet sich nicht auf der Blacklist.",
    BLACKLIST_UNBLACKLISTED: """
    ``{{user}}`` befindet sich nicht länger auf der Blacklist und kann nun wieder Befehle auf diesem Server verwenden.
    """,
    BLACKLIST_EMBED_TITLE: "Auf diesem Server gesperrt:",
    BLACKLIST_NOBODY_BLACKLISTED: "Niemand"
  }

  @config %{
    CONFIG_DESCRIPTION: """
    Setze, lese oder lösche einen Konfigurationseintrag.
    """,
    CONFIG_DESCRIPTION_LONG: """
    Setze, lese oder lösche einen Konfigurationseintrag.

    Aktuell unterstütze Schlüssel sind: `#{
      Util.Config.Guild.get_keys() |> Enum.map_join("`, `", &String.replace(&1, "_", ""))
    }`
    """,
    CONFIG_USAGES: """
    **Anwendungen**:
    - `config set <Schlüssel> <...Wert>`
    - `config get <Schlüssel>`
    - `config delete <Schlüssel>`
    """,
    CONFIG_EXAMPLES: """
    **Beispiele**:
    - `config set prefix c!`
    - `config get prefix`
    - `config delete prefix`
    """,
    CONFIG_INVALID_ACTION: "``{{action}}`` ist keine gültige Aktion.",
    CONFIG_INVALID_KEY: """
    Der angegebene Schlüssel ist nicht gültig.
    Gültige Schlüssel sind: `{{keys}``
    """,
    CONFIG_MISSING_VALUE: """
    Es muss ein neuer Wert für ``{{key}}`` angegeben werden.
    Zum Löschen, muss statt der `set` die `delete` Aktion verwedet werden.
    """,
    CONFIG_PUT_VALUE: "Setzte den neuen Wert für `{{key}}`.",
    CONFIG_VALUE: "Der aktuelle Wert für `{{key}}` ist: {{value}}",
    CONFIG_NO_VALUE: "Keine Konfiguration für `{{key}}` vorhanden.",
    CONFIG_DELETED: "Löschte die Konfiguration für `{{key}}`.",
    CONFIG_PREFIX_LENGTH: "Der Prefix kann maximal {{limit}} Zeichen lang sein.",
    CONFIG_LOCALE_UNKNOWN: """
    Diese Sprache wird nicht unterstüzt, versuche eine der Folgenden:
    {{locales}}
    """,
    CONFIG_NO_CHANNEL: "Das sieht mir nicht nach einem gültigen Channel aus."
  }

  @configstatus %{
    CONFIGSTATUS_DESCRIPTION: """
    Zeigt die aktuelle Konfigurationssituation für diesen Server an.
    """,
    CONFIGSTATUS_USAGES: "**Anwendung**: `config-status`",
    CONFIGSTATUS_EXAMPLES: "**Beispiel**: `config-status`",
    CONFIGSTATUS_RESPONSE: """
    Ein Überblick über die aktuelle Konfigurationssituation für diesen Server:
    ```asciidoc
    {{config}}
    ```
    Zum Ändern dieser Werte muss der ``config`` Befehl verwendet werden.
    """
  }

  @connected %{
    CONNECTED_BOT_NOT_CONNECTED: """
    Dieser Befehl erfordert, dass ich in einem Voicechannel bin, aber dies ist nicht der Fall.
    """,
    CONNECTED_USER_NOT_CONNECTED: """
    Dieser Befehl erfordert, dass Du in einem Voicechannel bist, aber dies ist nicht der Fall.
    """,
    CONNECTED_SUMMON_NOT_CONNECTED: """
    Dieser Befehl erfordert, dass ich in einem Voicechannel bin, aber dies ist nicht der Fall.
    Nutze den `play` Befehl.
    """,
    CONNECTED_SUMMON_SAME_CHANNEL: """
    Ich bin bereits hier.
    """,
    CONNECTED_DIFFERENT_CHANNELS: """
    Dieser Befehl erfordert, dass wir uns im selbem Voicechannel befinden, aber dies ist nicht der Fall.
    """
  }

  @dj %{
    DJ_CHANNEL: "Dieser Befehl kann nur im DJ Channel ausgeführt werden: {{channel}}.",
    DJ_ROLE: "Dieser Befehl kann nur von Nutzern mit der DJ Rolle ausgeführt werden: {{role}}."
  }

  @eval %{
    EVAL_DESCRIPTION: "Evaluate arbitrary code snippets.",
    EVAL_USAGES: "**Anwendung**: `eval [...code]`",
    EVAL_EXAMPLES: "**Beispiel**: `eval 2 = 1 + 1`"
  }

  @fetchguild %{
    FETCHGUILD_UNCACHED: """
    Dieser Server konnte nicht im Cache gefunden werden. Dies sollte nie passieren.
    """
  }

  @fetchmember %{
    FETCHMEMBER_FAILED: """
    Konnte ein benötigtes Servermitglied nicht von Discord abrufen. Dise sollte nicht passieren.
    """
  }

  @generic %{
    GENERIC_NO_ARGS: """
    Dieser Befehl benötigt zum Ausführen Argumente, und ich sehe hier keine.
    Nutze den `help` Befehl für mehr Informationen.
    """,
    GENERIC_NO_USER: "Ich konnte keinen Nutzer mithilfe von ``{{user}}`` finden."
  }

  @haspermissions %{
    HASPERMISSIONS_SELF_MISSING_PERMISSIONS: """
    Ich benötige folgende weitere Rechte (in diesem Channel) zum Ausführen dieses Befehls:
    {{permissions}}
    """,
    HASPERMISSIONS_MEMBER_MISSING_PERMISSIONS: """
    Du benötigst folgende weitere Rechte (in diesem Channel) zum Ausführen dieses Befehls:
    {{permissions}}
    """
  }

  @help %{
    HELP_DESCRIPTION: "Zeige einen Überlich an Befehlen oder Hilfe zu einem bestimmten an.",
    HELP_USAGES: """
    **Anwendungen**:
    - `help`
    - `help [Befehl]`
    """,
    HELP_EXAMPLES: """
    **Beispiele**:
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
    **Verfügbare Befehle**:
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
    HELP_UNKNOWN_COMMAND: "Ich kenne keinen solchen Befehl."
  }

  @info %{
    INFO_DESCRIPTION: "Zeigt allgemeine Informationen über den Bot an.",
    INFO_USAGES: "**Anwendung**: `info`",
    INFO_EXAMPLES: "**Beispiel**: `info`"
  }

  @invite %{
    INVITE_DESCRIPTION: "Lade den Bot zu deinen Server ein.",
    INVITE_USAGES: "**Anwendung**: `invite`",
    INVITE_EXAMPLES: "**Beispiel**: `invite`",
    INVITE: "Einladung",
    INVITE_EMBED_DESCRIPTION: """
    Um mich zu deinem Server einzuladen klicke [diesen]({{url}}) Link.
    **Notiz**: Du braucht **Server Verwalten** Rechte um mich einzuladen.
    \u200b
    """
  }

  @leave %{
    LEAVE_LEFT: "Stoppte die Wiedergabe und habe deinen Voicechannel verlassen."
  }

  @locale %{
    LOCALE_DESCRIPTION: "Setze oder lese die Sprache für diesen Server.",
    LOCALE_USAGES: """
    **Anwendungen**:
    - `locale` (lesen)
    - `locale [Sprache]` (setzen)
    """,
    LOCALE_EXAMPLES: """
    **Beispiele**:
    - `locale`
    - `locale EN`
    """
  }

  @loop %{
    LOOP_DESCRIPTION:
      ~s|Zeige, setze oder entferne den "Wiederholen" Modus für die aktuelle Wiedergabe.|,
    LOOP_USAGES: "**Anwendung**: `loop [NeuerModus]`",
    LOOP_EXAMPLES: """
    **Beispiele**:
    - `loop` (zeigen)
    - `loop y`
    - `loop enable`
    - `loop n`
    - `loop disable`
    """,
    LOOP_ENABLED: ~s|Die Wiedergabe ist im "Wiederholen" Modus.|,
    LOOP_DISABLED: ~s|Die Wiedergabe ist im normalen Modus.|,
    LOOP_INVALID_STATE: """
    Ich konnte das nicht als Status interpretieren, Beispiele können unter `help loop` gefunden werden.
    """,
    LOOP_UPDATED: "Habe erfolgreich den neuen Modus gesetzt.",
    LOOP_ALREADY: "Dies ist bereits der aktuelle Modus."
  }

  @nowplaying %{
    NOWPLAYING_DESCRIPTION: "Zeige den aktuelle gespielten Titel an.",
    NOWPLAYING_USAGES: "**Anwendung**: `nowplaying`",
    NOWPLAYING_EXAMPLES: "**Beispiel**: `nowplaying`"
  }

  @owneronly %{
    OWNERONLY: "Dieser Befehl kann von dir nicht verwendet werden."
  }

  @pause %{
    PAUSE_DESCRIPTION: "Pausiert die Wiedergabe.",
    PAUSE_USAGES: "**Anwendung**: `pause`",
    PAUSE_EXAMPLES: "**Beispiel**: `pause`",
    PAUSE_PAUSED: "Pausierte die Wiedergabe.",
    PAUSE_ALREADY: "Die Wiedergabe ist bereits pausiert."
  }

  @ping %{
    PING_DESCRIPTION: "Pong!",
    PING_USAGES: "**Anwendung**: `ping`",
    PING_EXAMPLES: "**Beispiel**: `ping`",
    PING_PONG: "Pong!",
    PING_TIME: "Pong! ({{ping}}ms)"
  }

  @play %{
    PLAY_DESCRIPTION: """
    Spiele einen Titel oder Playlist via Video- oder Playlist url sowie Suchbegriffe
    """,
    PLAY_USAGES: """
    **Anwendungen**:
    - `play <...Search>`
    - `play <Video-URL>`
    - `play <Playlist-URL>`
    """,
    PLAY_EXAMPLES: """
    **Beispiele**:
    - `play harito geist`
    - `play https://www.youtube.com/watch?v=xbx_t3YA9qQ`
    - `play https://www.youtube.com/playlist?list=PLLAAisT6WX23GeuJ44f0OLWAIygqQopck`
    """,
    PLAY_NOTHING_FOUND: "Ich konnte nichts finden.",
    PLAY_START: "Starte die Wiedergabe..."
  }

  @prefix %{
    PREFIX_DESCRIPTION: "Setze oder lese den aktuellen Prefix auf diesem Server.",
    PREFIX_USAGES: """
    **Anwendungen**:
    - get `prefix`
    - set `prefix [prefix]`
    """,
    PREFIX_EXAMPLES: """
    **Beispiele**:
    - get `prefix`
    - set `prefix c!`
    """
  }

  @queue %{
    QUEUE_DESCRIPTION: "Zeige die Warteschlange an.",
    QUEUE_USAGES: "**Anwendung**: `queue [Page]`",
    QUEUE_EXAMPLES: """
    **Beispiele**:
    - `queue`
    - `queue 2`
    """,
    QUEUE_LESS_THAN_ONE: "Seitenzahlen fangen bei 1 an.",
    QUEUE_NAN: "Ich konnte das nicht als Zahl interpretieren.",
    QUEUE_EMBED_TITLE:
      "Titel in der Warteschlange: {{queue_length}} | Gesamtspiellänge: {{queue_time}}",
    QUEUE_PAGES: "Seite {{page}} von {{max_page}}",
    QUEUE_EMBED_DESCRIPTION: """
    {{current}}

    Warteschlange:
    {{queue}}
    """
  }

  @remove %{
    REMOVE_DESCRIPTION:
      "Entferne einen oder mehrere Titel ab der gegeben Warteschlangenposition.",
    REMOVE_USAGES: "**Anwendung**: `remove <Position> [Anzahl]",
    REMOVE_EXAMPLES: """
    **Beispiele**:
    - `remove 1` (Entfernt den ersten Titel in der Warteschlange)
    - `remove 1 1` (Selbe wie darüber)
    - `remove 1 2` (Entfernt die ersten beiden Titel in der Warteschlange)
    """,
    REMOVE_POSITION_NAN: "Ich konnte die angegebene Position nicht als Zahl interpretieren.",
    REMOVE_COUNT_NAN: "Ich konnte die angegebene Anzahl nicht als Zahl interpretieren.",
    REMOVE_POSITION_NEGATIVE: """
    Die angegebene Position ist negativ, sie muss positiv sein.
    """,
    REMOVE_COUNT_SMALLER_ONE: """
    Die angegebene Position ist kleiner als 1, sie muss mindestens 1 sein.
    """,
    REMOVE_POSITION_OUT_OF_BOUNDS: """
    Die Position ist zu groß, so viele Titel befinden sich nicht in der Warteschlange
    """,
    REMOVE_REMOVED: "Entferne {{count}} Titel."
  }

  @resume %{
    RESUME_DESCRIPTION: "Setze die Wiedergabe fort.",
    RESUME_USAGES: "**Anwendung**: `resume`",
    RESUME_EXAMPLES: "**Beispiel**: `resume`",
    RESUME_RESUMED: "Setzte die Wiedergabe fort.",
    RESUME_ALREADY: "Hier gibt es nichts fortzusetzen."
  }

  @save %{
    SAVE_DESCRIPTION: "Sichere den aktuell gespielten Titel in deine Direktnachrichten.",
    SAVE_USAGES: "**Anwendung**: `save`",
    SAVE_EXAMPLES: "**Beispiel**: `save`"
  }

  @shuffle %{
    SHUFFLE_DESCRIPTION: "Mische die Warteschlange.",
    SHUFFLE_USAGES: "**Anwendung**: `shuffle`",
    SHUFFLE_EXAMPLES: "**Beispiel**: `shuffle`",
    SHUFFLE_SHUFFLED: "Mischte die Warteschlange."
  }

  @skip %{
    SKIP_DESCRIPTION: "Überspringe einen oder mehrere Titel.",
    SKIP_USAGES: "**Anwendung**: `skip [Anzahl]`",
    SKIP_EXAMPLES: """
    **Beispiele**:
    - `skip` (Der Aktuelle Titel)
    - `skip 1` (Selbe wie oben)
    - `skip 5`
    """,
    SKIP_LESS_THAN_ONE: "Anzahl muss mindestens 1 sein.",
    SKIP_NAN: "Ich konnte diese Anzahl nicht als Zahl interpretieren.",
    SKIP_SKIPPED: "Übersprang {{count}} Titel."
  }

  @stop %{
    STOP_DESCRIPTION: "Stoppe die Wiedergabe und verlasse den Voicechannel.",
    STOP_USAGES: "**Anwendung**: `stop`",
    STOP_EXAMPLES: "**Beispiel**: `stop`"
  }

  @summon %{
    SUMMON_DESCRIPTION: "Rufe mich von einem anderen in deinen Voicechannel.",
    SUMMON_USAGES: "**Anwendung**: `summon`",
    SUMMON_EXAMPLES: "**Beispiel**: `summon`",
    SUMMON_SUMMONED: "Trete deinem Voicechannel bei..."
  }

  @track %{
    TRACK_LOOP: """
    **Die Warteschlange wird wiederholt**
    {{rest}}
    """,
    TRACK_POSITION: """
    {{uri}}
    Zeit: (`{{position}}` / `{{length}}`)
    """,
    TRACK_INFO: """
    {{uri}}
    Länge: {{length}}
    """,
    TRACK_LENGTH_DAYS: "{{days}} Tage {{rest}}",
    TRACK_DESCRIPTION: "{{prefix}} {{info}}",
    TRACK_SAVE: "gesichert, nur für dich",
    TRACK_PLAY: "wird gerade gespielt",
    TRACK_ADD: "wurde hinzugefügt",
    TRACK_NOW_PLAYING: "im moment gespielt",
    TRACK_END: "endete",
    TRACK_PAUSE: "ist pausiert"
  }

  @uptime %{
    UPTIME_DESCRIPTION: "Zeige die aktuelle Betriebszeit des Bots an.",
    UPTIME_USAGES: "**Anwendung**: `uptime`",
    UPTIME_EXAMPLES: "**Beispiel**: `uptime`",
    UPTIME: """
    **Betriebszeit:**
    ```asciidoc
    {{content}}
    ```
    """
  }

  @voicelog %{
    VOICELOG_JOINED: "{{user}} loggte sich in {{new_channel}} ein.",
    VOICELOG_LEFT: "{{user}} loggte sich aus {{old_channel}} aus.",
    VOICELOG_MOVED: "{{user}} ging von {{old_channel}} nach {{new_channel}}."
  }

  @volume %{
    VOLUME_DESCRIPTION: "Setze oder lese die Lautstärke der Wiedergabe.",
    VOLUME_USAGES: "**Anwendung**: `volume [NeueLautstärke]",
    VOLUME_EXAMPLES: """
    **Beispiele**:
    - `volume` (lese aktuelle)
    - `volume 0` (setze neue)
    """,
    VOLUME_CURRENT: "Die aktuelle Lautstärke ist {{volume}}/1000",
    VOLUME_SET: "Neue Lautstärke gesetzt.",
    VOLUME_NAN: "Ich konnte diese Lautstärke nicht als Zahl interpretieren.",
    VOLUME_OUT_OF_BOUNDS: "Die Lautstärke muss mindestens 0 und maximal 1000 sein."
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
      require Logger
      message = "Fehlender oder nicht übersetzter Schlüssel: #{key}!"

      Logger.error(fn -> message end)

      "ERROR: " <> message
    end)
  end
end
