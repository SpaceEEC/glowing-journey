# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger, :console,
  format: {Rpc.Logger, :format},
  metadata: [:module, :function]

unless Mix.env() == :prod do
  import_config "./config.secret.exs"
end

config :sentry,
  environment_name: Mix.env(),
  included_environments: [:prod],
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  json_library: Jason,
  log_level: :error,
  server_name: ""
