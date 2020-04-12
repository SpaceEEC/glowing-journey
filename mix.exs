defmodule Bot.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: releases(),
      version: "0.0.1-dev"
    ]
  end

  @cookie "DFW6GOl6zh81fM0r9y7yrirTv2FhjtM9bAu2-X7Qn0GRrubawwxFyQ=="

  defp releases do
    [
      all_in_one: [
        applications: [
          rest: :permanent,
          gateway: :permanent,
          cache: :permanent,
          worker: :permanent,
          lavalink: :permanent
        ]
      ],
      rest: [cookie: @cookie, applications: [rest: :permanent]],
      gateway: [cookie: @cookie, applications: [gateway: :permanent]],
      cache: [cookie: @cookie, applications: [cache: :permanent]],
      worker: [cookie: @cookie, applications: [worker: :permanent]],
      lavalink: [cookie: @cookie, applications: [lavalink: :permanent]]
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
      {:crux_rest, github: "spaceeec/crux_rest", override: true},
      {:httpoison, "~> 1.6.2", override: true}
    ]
  end

  defp aliases do
    [sentry_compile: ["compile", "deps.compile sentry --force"]]
  end
end
