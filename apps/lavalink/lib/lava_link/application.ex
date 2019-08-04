defmodule LavaLink.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Rpc.Sentry.install()

    # List all child processes to be supervised
    children = [
      {LavaLink.Player, {LavaLink.Player.opts(), name: LavaLink.Player.name()}}
    ]

    opts = [strategy: :one_for_one, name: LavaLink.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
