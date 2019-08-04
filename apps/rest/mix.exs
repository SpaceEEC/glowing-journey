defmodule Rest.MixProject do
  use Mix.Project

  def project do
    [
      app: :rest,
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

  def application do
    [
      extra_applications: [:logger],
      mod: {Rest.Application, []}
    ]
  end

  defp deps do
    [
      {:rpc, in_umbrella: true},
      {:crux_rest, "~> 0.2.0"}
    ]
  end
end
