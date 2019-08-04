defmodule Rest.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Rpc.Sentry.install()

    token = Application.fetch_env!(:rest, :token)

    children = [
      {Rest, token: token}
    ]

    opts = [strategy: :one_for_one, name: Rest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
