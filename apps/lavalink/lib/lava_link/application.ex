defmodule LavaLink.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Rpc

  def start(_type, _args) do
    Rpc.Sentry.install()

    unless Rpc.is_offline() do
      Application.put_env(:sentry, :tags, %{node: node()})
    end

    # List all child processes to be supervised
    children = [
      {LavaLink.Player, {LavaLink.Player.opts(), name: LavaLink.Player.name()}}
    ]

    opts = [strategy: :one_for_one, name: LavaLink.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
