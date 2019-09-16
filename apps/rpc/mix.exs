defmodule Rpc.MixProject do
  use Mix.Project

  def project do
    [
      app: :rpc,
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
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sentry, github: "SpaceEEC/sentry-elixir", branch: "fix/umbrella"},
      {:jason, ">= 0.0.0"},
      {:crux_rest, "~> 0.2"}
    ]
  end
end
