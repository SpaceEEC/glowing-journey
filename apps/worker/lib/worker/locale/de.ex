defmodule Worker.Locale.DE do
  @behaviour Worker.Locale

  def code(), do: "DE"
  def friendly_name(), do: "German (Deutsch)"

  @blacklist %{
    LOC_BLACKLIST_DESCRIPTION: "Blacklist or unblacklist a user or guild.",
    LOC_BLACKLIST_USAGES: """
    **Anwendungen**:
    - `blacklist` (get all)
    - `blacklist [UserID|GuildID]` (blacklist)
    - `blacklist remove [UserID|GuilID]` (unblacklist)
    """,
    LOC_BLACKLIST_EXAMPLES: """
    **Beispiele**:
    - `blacklist` (get all)
    - `blacklist 218348062828003328` (blacklist)
    - `blacklist remove 218348062828003328` (unblacklist)
    """
  }

  @config %{
    LOC_CONFIG_DESCRIPTION: """
    Setze, lese oder lösche einen Konfigurationseintrag.
    """,
    LOC_CONFIG_DESCRIPTION_LONG: """
    Setze, lese oder lösche einen Konfigurationseintrag.

    Aktuell unterstütze Schlüssel sind: `#{
      Worker.Config.Guild.get_keys() |> Enum.map_join("`, `", &String.replace(&1, "_", ""))
    }`
    """,
    LOC_CONFIG_USAGES: """
    **Anwendungen**:
    - `config set <Schlüssel> <...Wert>`
    - `config get <Schlüssel>`
    - `config delete <Schlüssel>`
    """,
    LOC_CONFIG_EXAMPLES: """
    **Beispiele**:
    - `config set prefix c!`
    - `config get prefix`
    - `config delete prefix`
    """,
    LOC_CONFIG_INVALID_ACTION: "``{{action}}`` ist keine gültige Aktion.",
    LOC_CONFIG_INVALID_KEY: "Der angegebene Schlüssel ist nicht gültig.",
    LOC_CONFIG_MISSING_VALUE: """
    Es muss ein neuer Wert für ``{{key}}`` angegeben werden.
    Zum Löschen, muss statt der `set` die `delete` Aktion verwedet werden.
    """,
    LOC_CONFIG_PUT_VALUE: "Setzte den neuen Wert für `{{key}}`.",
    LOC_CONFIG_VALUE: "Der aktuelle Wert für `{{key}}` ist: {{value}}",
    LOC_CONFIG_NO_VALUE: "Keine Konfiguration für `{{key}}` vorhanden.",
    LOC_CONFIG_DELETED: "Löschte die Konfiguration für `{{key}}`.",
    LOC_CONFIG_PREFIX_LENGTH: "Der Prefix kann maximal {{limit}} Zeichen lang sein.",
    LOC_CONFIG_LOCALE_UNKNOWN: """
    Diese Sprache wird nicht unterstüzt, versuche eine der Folgenden:
    {{locales}}
    """,
    LOC_CONFIG_NO_CHANNEL: "Das sieht mir nicht nach einem gültigen Channel aus."
  }

  @configstatus %{
    LOC_CONFIGSTATUS_DESCRIPTION: """
    Zeigt die aktuelle Konfigurationssituation für diesen Server an.
    """,
    LOC_CONFIGSTATUS_USAGES: "**Anwendung**: `config-status`",
    LOC_CONFIGSTATUS_EXAMPLES: "**Beispiel**: `config-status`",
    LOC_CONFIGSTATUS_RESPONSE: """
    Ein Überblick über die aktuelle Konfigurationssituation für diesen Server:
    ```asciidoc
    {{config}}
    ```
    Zum Ändern dieser muss der ``config`` Befehl verwendet werden.
    """
  }

  @connected %{
    LOC_CONNECTED_BOT_NOT_CONNECTED: """
    Dieser Befehl erfordert, dass ich in einem Voicechannel bin, aber dies ist nicht der Fall.
    """,
    LOC_CONNECTED_USER_NOT_CONNECTED: """
    Dieser Befehl erfordert, dass Du in einem Voicechannel bist, aber dies ist nicht der Fall.
    """,
    LOC_CONNECTED_SUMMON_NOT_CONNECTED: """
    Dieser Befehl erfordert, dass ich in einem Voicechannel bin, aber dies ist nicht der Fall.
    Nutze den `play` Befehl.
    """,
    LOC_CONNECTED_SUMMON_SAME_CHANNEL: """
    Ich bin bereits hier.
    """,
    LOC_CONNECTED_DIFFERENT_CHANNELS: """
    Dieser Befehl erfordert, dass wir uns im selbem Voicechannel befinden, aber dies ist nicht der Fall.
    """
  }

  @dj %{
    LOC_DJ_CHANNEL: "Dieser Befehl kann nur im DJ Channel ausgeführt werden: {{channel}}.",
    LOC_DJ_ROLE:
      "Dieser Befehl kann nur von Nutzern mit der DJ Rolle ausgeführt werden: {{role}}."
  }

  @eval %{
    LOC_EVAL_DESCRIPTION: "Evaluate arbitrary code snippets.",
    LOC_EVAL_USAGES: "**Anwendung**: `eval [...code]`",
    LOC_EVAL_EXAMPLES: "**Beispiel**: `eval 2 = 1 + 1`"
  }

  @fetchguild %{
    LOC_FETCHGUILD_UNCACHED: """
    Dieser Server konnte nicht im Cache gefunden werden. Dies sollte nie passieren.
    """
  }

  @fetchmember %{
    LOC_FETCHMEMBER_FAILED: """
    Konnte ein benötigtes Servermitglied nicht von Discord abrufen. Dise sollte nicht passieren.
    """
  }

  @generic %{
    LOC_GENERIC_NO_ARGS: """
    Dieser Befehl benötigt zum Ausführen Argumente, und ich sehe hier keine.
    Nutze den `help` Befehl für mehr Informationen.
    """
  }

  @haspermissions %{
    LOC_HASPERMISSIONS_SELF_MISSING_PERMISSIONS: """
    Ich benötige folgende weitere Rechte (in diesem Channel) zum Ausführen dieses Befehls:
    {{permissions}}
    """,
    LOC_HASPERMISSIONS_MEMBER_MISSING_PERMISSIONS: """
    Du benötigst folgende weitere Rechte (in diesem Channel) zum Ausführen dieses Befehls:
    {{permissions}}
    """
  }

  @help %{
    LOC_HELP_DESCRIPTION: "Zeige einen Überlich an Befehlen oder Hilfe zu einem bestimmten an.",
    LOC_HELP_USAGES: """
    **Anwendungen**:
    - `help`
    - `help [Befehl]`
    """,
    LOC_HELP_EXAMPLES: """
    **Beispiele**:
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
    **Verfügbare Befehle**:
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
    LOC_HELP_UNKNOWN_COMMAND: "Ich kenne keinen solchen Befehl."
  }

  @info %{
    LOC_INFO_DESCRIPTION: "Zeigt allgemeine Informationen über den Bot an.",
    LOC_INFO_USAGES: "**Anwendung**: `info`",
    LOC_INFO_EXAMPLES: "**Beispiel**: `info`"
  }

  @invite %{
    LOC_INVITE_DESCRIPTION: "Lade den Bot zu deinen Server ein.",
    LOC_INVITE_USAGES: "**Anwendung**: `invite`",
    LOC_INVITE_EXAMPLES: "**Beispiel**: `invite`",
    LOC_INVITE: "Einladung",
    LOC_INVITE_EMBED_DESCRIPTION: """
    Um mich zu deinem Server einzuladen klicke [diesen]({{url}}) Link.
    **Notiz**: Du braucht **Server Verwalten** Rechte um mich einzuladen.
    \u200b
    """
  }

  @leave %{
    LOC_LEAVE_LEFT: "Stoppte die Wiedergabe und habe deinen Voicechannel verlassen."
  }

  @locale %{
    LOC_LOCALE_DESCRIPTION: "Setze oder lese die Sprache für diesen Server.",
    LOC_LOCALE_USAGES: """
    **Anwendungen**:
    - `locale` (lesen)
    - `locale [Sprache]` (setzen)
    """,
    LOC_LOCALE_EXAMPLES: """
    **Beispiele**:
    - `locale`
    - `locale EN`
    """
  }

  @loop %{
    LOC_LOOP_DESCRIPTION:
      ~s|Zeige, setze oder entferne den "Wiederholen" Modus für die aktuelle Wiedergabe.|,
    LOC_LOOP_USAGES: "**Anwendung**: `loop [NeuerModus]`",
    LOC_LOOP_EXAMPLES: """
    **Beispiele**:
    - `loop` (zeigen)
    - `loop y`
    - `loop enable`
    - `loop n`
    - `loop disable`
    """,
    LOC_LOOP_ENABLED: ~s|Die Wiedergabe ist im "Wiederholen" Modus.|,
    LOC_LOOP_DISABLED: ~s|Die Wiedergabe ist im normalen Modus.|,
    LOC_LOOP_INVALID_STATE: """
    Ich konnte das nicht als Status interpretieren, Beispiele können unter `help loop` gefunden werden.
    """,
    LOC_LOOP_UPDATED: "Habe erfolgreich den neuen Modus gesetzt.",
    LOC_LOOP_ALREADY: "Dies ist bereits der aktuelle Modus."
  }

  @nowplaying %{
    LOC_NOWPLAYING_DESCRIPTION: "Zeige den aktuelle gespielten Titel an.",
    LOC_NOWPLAYING_USAGES: "**Anwendung**: `nowplaying`",
    LOC_NOWPLAYING_EXAMPLES: "**Beispiel**: `nowplaying`"
  }

  @owneronly %{
    LOC_OWNERONLY: "Dieser Befehl kann von dir nicht verwendet werden."
  }

  @pause %{
    LOC_PAUSE_DESCRIPTION: "Pausiert die Wiedergabe.",
    LOC_PAUSE_USAGES: "**Anwendung**: `pause`",
    LOC_PAUSE_EXAMPLES: "**Beispiel**: `pause`",
    LOC_PAUSE_PAUSED: "Pausierte die Wiedergabe.",
    LOC_PAUSE_ALREADY: "Die Wiedergabe ist bereits pausiert."
  }

  @ping %{
    LOC_PING_DESCRIPTION: "Pong!",
    LOC_PING_USAGES: "**Anwendung**: `ping`",
    LOC_PING_EXAMPLES: "**Beispiel**: `ping`",
    LOC_PING_PONG: "Pong!",
    LOC_PING_TIME: "Pong! ({{ping}}ms)"
  }

  @play %{
    LOC_PLAY_DESCRIPTION: """
    Spiele einen Titel oder Playlist via Video- oder Playlist url sowie Suchbegriffe
    """,
    LOC_PLAY_USAGES: """
    **Anwendungen**:
    - `play <...Search>`
    - `play <Video-URL>`
    - `play <Playlist-URL>`
    """,
    LOC_PLAY_EXAMPLES: """
    **Beispiele**:
    - `play harito geist`
    - `play https://www.youtube.com/watch?v=xbx_t3YA9qQ`
    - `play https://www.youtube.com/playlist?list=PLLAAisT6WX23GeuJ44f0OLWAIygqQopck`
    """,
    LOC_PLAY_NOTHING_FOUND: "Ich konnte nichts finden.",
    LOC_PLAY_START: "Starte die Wiedergabe..."
  }

  @prefix %{
    LOC_PREFIX_DESCRIPTION: "Setze oder lese den aktuellen prefix in diesem Server.",
    LOC_PREFIX_USAGES: """
    **Anwendungen**:
    - get `prefix`
    - set `prefix [prefix]`
    """,
    LOC_PREFIX_EXAMPLES: """
    **Beispiele**:
    - get `prefix`
    - set `prefix c!`
    """
  }

  @queue %{
    LOC_QUEUE_DESCRIPTION: "Zeige die Warteschlange an.",
    LOC_QUEUE_USAGES: "**Anwendung**: `queue [Page]`",
    LOC_QUEUE_EXAMPLES: """
    **Beispiele**:
    - `queue`
    - `queue 2`
    """,
    LOC_QUEUE_LESS_THAN_ONE: "Seitenzahlen fangen bei 1 an.",
    LOC_QUEUE_NAN: "Ich konnte das nicht als Zahl interpretieren.",
    LOC_QUEUE_EMBED_TITLE:
      "Titel in der Warteschlange: {{queue_length}} | Gesamtspiellänge: {{queue_time}}",
    LOC_QUEUE_PAGES: "Seite {{page}} von {{max_page}}",
    LOC_QUEUE_EMBED_DESCRIPTION: """
    {{current}}

    Warteschlange:
    {{queue}}
    """
  }

  @remove %{
    LOC_REMOVE_DESCRIPTION:
      "Entferne einen oder mehrere Titel ab der gegeben Warteschlangenposition.",
    LOC_REMOVE_USAGES: "**Anwendung**: `remove <Position> [Anzahl]",
    LOC_REMOVE_EXAMPLES: """
    **Beispiele**:
    - `remove 1` (Entfernt den ersten Titel in der Warteschlange)
    - `remove 1 1` (Selbe wie darüber)
    - `remove 1 2` (Entfernt die ersten beiden Titel in der Warteschlange)
    """,
    LOC_REMOVE_POSITION_NAN: "Ich konnte die angegebene Position nicht als Zahl interpretieren.",
    LOC_REMOVE_COUNT_NAN: "Ich konnte die angegebene Anzahl nicht als Zahl interpretieren.",
    LOC_REMOVE_POSITION_NEGATIVE: """
    Die angegebene Position ist negativ, sie muss positiv sein.
    """,
    LOC_REMOVE_COUNT_SMALLER_ONE: """
    Die angegebene Position ist kleiner als 1, sie muss mindestens 1 sein.
    """,
    LOC_REMOVE_POSITION_OUT_OF_BOUNDS: """
    Die Position ist zu groß, so viele Titel befinden sich nicht in der Warteschlange
    """,
    LOC_REMOVE_REMOVED: "Entferne {{count}} Titel."
  }

  @resume %{
    LOC_RESUME_DESCRIPTION: "Setze die Wiedergabe fort.",
    LOC_RESUME_USAGES: "**Anwendung**: `resume`",
    LOC_RESUME_EXAMPLES: "**Beispiel**: `resume`",
    LOC_RESUME_RESUMED: "Setzte die Wiedergabe fort.",
    LOC_RESUME_ALREADY: "Hier gibt es nichts fortzusetzen."
  }

  @save %{
    LOC_SAVE_DESCRIPTION: "Sichere den aktuell gespielten Titel in deine Direktnachrichten.",
    LOC_SAVE_USAGES: "**Anwendung**: `save`",
    LOC_SAVE_EXAMPLES: "**Beispiel**: `save`"
  }

  @shuffle %{
    LOC_SHUFFLE_DESCRIPTION: "Mische die Warteschlange.",
    LOC_SHUFFLE_USAGES: "**Anwendung**: `shuffle`",
    LOC_SHUFFLE_EXAMPLES: "**Beispiel**: `shuffle`",
    LOC_SHUFFLE_SHUFFLED: "Mischte die Warteschlange."
  }

  @skip %{
    LOC_SKIP_DESCRIPTION: "Überspringe einen oder mehrere Titel.",
    LOC_SKIP_USAGES: "**Anwendung**: `skip [Anzahl]`",
    LOC_SKIP_EXAMPLES: """
    **Beispiele**:
    - `skip` (Der Aktuelle Titel)
    - `skip 1` (Selbe wie oben)
    - `skip 5`
    """,
    LOC_SKIP_LESS_THAN_ONE: "Anzahl muss mindestens 1 sein.",
    LOC_SKIP_NAN: "Ich konnte diese Anzahl nicht als Zahl interpretieren.",
    LOC_SKIP_SKIPPED: "Übersprang {{count}} Titel."
  }

  @stop %{
    LOC_STOP_DESCRIPTION: "Stoppe die Wiedergabe und verlasse den Voicechannel.",
    LOC_STOP_USAGES: "**Anwendung**: `stop`",
    LOC_STOP_EXAMPLES: "**Beispiel**: `stop`"
  }

  @summon %{
    LOC_SUMMON_DESCRIPTION: "Rufe mich von einem anderen in deinen Voicechannel.",
    LOC_SUMMON_USAGES: "**Anwendung**: `summon`",
    LOC_SUMMON_EXAMPLES: "**Beispiel**: `summon`",
    LOC_SUMMON_SUMMONED: "Trete deinem Voicechannel bei..."
  }

  @track %{
    LOC_TRACK_LOOP: """
    **Die Warteschlange wird wiederholt**
    {{rest}}
    """,
    LOC_TRACK_POSITION: """
    {{uri}}
    Zeit: (`{{position}}` / `{{length}}`)
    """,
    LOC_TRACK_INFO: """
    {{uri}}
    Länge: {{length}}
    """,
    LOC_TRACK_LENGTH_DAYS: "{{days}} Tage {{rest}}",
    LOC_TRACK_DESCRIPTION: "{{prefix}} {{info}}",
    LOC_TRACK_SAVE: "gesichert, nur für dich",
    LOC_TRACK_PLAY: "wird gerade gespielt",
    LOC_TRACK_ADD: "wurde hinzugefügt",
    LOC_TRACK_NOW_PLAYING: "im moment gespielt",
    LOC_TRACK_END: "endete",
    LOC_TRACK_PAUSE: "ist pausiert"
  }

  @uptime %{
    LOC_UPTIME_DESCRIPTION: "Zeige die aktuelle Betriebszeit des Bots an.",
    LOC_UPTIME_USAGES: "**Anwendung**: `uptime`",
    LOC_UPTIME_EXAMPLES: "**Beispiel**: `uptime`",
    LOC_UPTIME: """
    **Betriebszeit:**
    ```asciidoc
    {{content}}
    ```
    """
  }

  @volume %{
    LOC_VOLUME_DESCRIPTION: "Setze oder lese die Lautstärke der Wiedergabe.",
    LOC_VOLUME_USAGES: "**Anwendung**: `volume [NeueLautstärke]",
    LOC_VOLUME_EXAMPLES: """
    **Beispiele**:
    - `volume` (lese aktuelle)
    - `volume 0` (setze neue)
    """,
    LOC_VOLUME_CURRENT: "Die aktuelle Lautstärke ist {{volume}}/1000",
    LOC_VOLUME_SET: "Neue Lautstärke gesetzt.",
    LOC_VOLUME_NAN: "Ich konnte diese Lautstärke nicht als Zahl interpretieren.",
    LOC_VOLUME_OUT_OF_BOUNDS: "Die Lautstärke muss mindestens 0 und maximal 1000 sein."
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
                |> Map.merge(@volume, &Worker.Locale.raise_duplicate_key/3)

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
