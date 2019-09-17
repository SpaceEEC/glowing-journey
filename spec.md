# Feature Overview

- Join / Leave Messages
- Voice Log
- Music
- Custom Guild Prefix
- Localization
- - German (unhandled error messages are and will not be localized though)
- - English
- Help (also List)
- Info (General application stats)
- Blacklist (Users and Guilds)
- eval (debug and stuff)

# Commands

## Config

#### `config`

Description: Sets, gets, or delete a key in the configuration.

Syntax: `config <key> <action> [value]`

`<key>`: `joinmessage` | `leavemessage` | `joinchannel` | `leavechannel` | `voicelogchannel` | `djrole` | `djchannel` | `volume` | `prefix` | `locale`

`<action>`: `set` | `get` | `delete`

`<value>`: String | ChannelID | RoleID | Locale
> Type and limitations thereof depend on the `<key>`

#### `config-status`

Description: Shows a general overview about the current configuration status.

Syntax: `config-status`

#### `prefix`

Description: Sets or shows the prefix for the current guild.

Syntax: `prefix [newprefix]`

> This is just a shortcut to `config prefix set <newprefix>` or `config get prefix` depending on whether a new prefix is provided.

#### `locale`

Description: Sets or shows the locale for the current guild.

Syntax: `locale [newlocale]`
Aliases: `language` | `lang`

> This is just a shortcut to `config locale set <newlocale>` or `config get locale` depending on whether arguments are provided or not.

## Music

### "Control Flow"

#### `play`

Description: Plays a track via url or search.

Syntax: `play <URL|Search>`

#### `stop`

Description: Stops the playback makes the bot leave the channel.

Syntax: `stop`

#### `skip`

Description: Skips the first `<Count>` tracks. Defaults to 1.

Syntax: `skip <Count>`

#### `remove`

Description: Removes the track at `<Position>`.

Syntax: `remove <Position>`

#### `loop`

Descriptions: Shows or sets the loop status.

Syntax: `loop [newstatus]`

#### `shuffle`

Description: Shuffles the queue.

Syntax: `shuffle`

#### `pause`

Description: Pauses the playback.

Syntax: `pause`

#### `resume`

Description: Resumves the playback.

Syntax: `resume`

#### `summon`

Description: Summons the bot into the current voice channel of the caller.

Syntax: `summon`

### "Information"

#### `now playing`

Description: Shows the currently played song.

Syntax: `nowPlaying`
Aliases: `np`

#### `queue`

Description: Shows the queue, if empty acts as `nowplaying`.

Syntax: `queue [page]`
Aliases: `q`

#### `save`

Description: "Saves" the currently played song into dms.

Syntax: `save`


## Misc

#### `avatar`

Description: Shows the avatar of the requested user.

Syntax `avatar <User>`

#### `help`

Description: Shows a list of commands or detailed help for single one.

Syntax: `help [command]`

#### `info`

Description: Shows general info about the bot and its systems.

Syntax: `info`

#### `invite`

Description: Sends an invite link to invite the bot.

Syntax: `invite`

#### `ping`

Description: Sends `pong`

Syntax: `ping`

#### `uptime`

Description: Sends the uptime of the bot

Syntax: `uptime`

## Hidden

#### `blacklist`

Description: Blacklists a user or guild from using the bot.

Syntax: `blacklist [remove] <UserID|GuildID>`

#### `eval`

Description: Evaluates arbitrary code. Intended for debugging purposes.

Syntax: `eval <...code>`