defmodule Rest.Application do
  @moduledoc false

  use Application
  require Rpc

  def start(_type, _args) do
    Rpc.Sentry.install()

    unless Rpc.is_offline() do
      Application.put_env(:sentry, :tags, %{node: node()})
    end

    token = Application.fetch_env!(:rest, :token)

    children = [
      {Rest, token: token}
    ]

    opts = [strategy: :one_for_one, name: Rest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
