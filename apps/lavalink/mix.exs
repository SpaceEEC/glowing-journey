defmodule LavaLink.MixProject do
  use Mix.Project

  def project do
    [
      app: :lavalink,
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
      mod: {LavaLink.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rpc, in_umbrella: true},
      {:ex_link, github: "spaceeec/ex_link"},
      {:httpoison, "~> 1.1.1"}
    ]
  end
end
