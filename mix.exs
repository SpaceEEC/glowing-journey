defmodule Bot.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      # TODO: remove once >= 0.2.1 released
      {:crux_rest, github: "spaceeec/crux_rest", override: true}
    ]
  end

  defp aliases do
    [sentry_recompile: ["compile", "deps.compile sentry --force"]]
  end
end
