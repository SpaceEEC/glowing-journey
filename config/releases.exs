import Config

fetch_env! = &System.fetch_env!/1

fetch_env = fn
  name, default ->
    case System.fetch_env(name) do
      {:ok, val} ->
        val

      :error ->
        default
    end
end

# Required
discord_token = fetch_env!.("DISCORD_TOKEN")
lavalink_authorization = fetch_env!.("LAVALINK_AUTHORIZATION")
# Optional
sentry_dsn = fetch_env.("SENTRY_DSN", nil)
lavalink_authority = fetch_env.("LAVALINK_AUTHORITY", "localhost:2333")
etcd_base_url = fetch_env.("ETCD_URL", "http://localhost:2379/v3beta/kv")
default_locale = fetch_env.("DEFAULT_LOCALE", "EN")
default_prefix = fetch_env.("DISCORD_PREFIX", "?")
discord_owners = fetch_env.("DISCORD_OWNERS", "")
# comma separated ids ^

user_id =
  discord_token
  |> String.split(".", parts: 2)
  |> List.first()
  |> Base.decode64!()
  |> String.to_integer()

config :sentry, dsn: sentry_dsn

config :rest, token: discord_token
config :gateway, token: discord_token

config :worker, user_id: user_id

config :lavalink,
  lavalink_authority: lavalink_authority,
  lavalink_authorization: lavalink_authorization,
  user_id: user_id

config :util,
  etcd_base_url: etcd_base_url,
  default_locale: String.to_atom("Util.Locale." <> default_locale)

config :worker,
  default_prefix: default_prefix,
  owners:
    discord_owners
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.wrap()
