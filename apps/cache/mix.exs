defmodule Cache.MixProject do
  use Mix.Project

  def project do
    [
      app: :cache,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Cache.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rpc, in_umbrella: true},
      {:crux_cache, "~> 0.2.0"},
      {:crux_base, git: "https://github.com/spaceeec/crux_base"}
    ]
  end
end
