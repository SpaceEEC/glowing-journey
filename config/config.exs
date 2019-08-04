# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger, :console,
  format: {Rpc.Logger, :format},
  metadata: [:module, :function]

import_config "./config.secret.exs"

config :lavalink, :lavalink_authority, "localhost:2333"

config :worker,
  etcd_base_url: "http://localhost:2379/v3beta/kv",
  default_prefix: "-",
  default_locale: Worker.Locale.EN,
  owners: [218_348_062_828_003_328]

config :sentry,
  environment_name: Mix.env(),
  included_environments: [:prod],
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  json_library: Poison,
  log_level: :error
