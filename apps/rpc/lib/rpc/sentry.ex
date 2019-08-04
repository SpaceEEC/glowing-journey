defmodule Rpc.Sentry do
  def install() do
    case Logger.add_backend(Sentry.LoggerBackend) do
      {:ok, _} -> :ok
      {:error, :already_present} -> :ok
      {:error, {:already_started, _}} -> :ok
    end
  end
end
