defmodule Rpc.Sentry do
  def install() do
    case Logger.add_backend(Sentry.LoggerBackend) do
      {:ok, _} -> :ok
      {:error, :already_present} -> :ok
      {:error, {:already_started, _}} -> :ok
    end
  end

  defp get_source(%{module: mod, function: {fun, arity}}) do
    Exception.format_mfa(mod, fun, arity)
  end

  defmacro debug(message, category) do
    source = get_source(__CALLER__)

    quote bind_quoted: [message: message, category: category, source: source] do
      require Logger
      Logger.debug(message)

      Elixir.Sentry.Context.add_breadcrumb(
        category: category,
        message: message,
        data: %{source: source},
        level: "debug"
      )
    end
  end

  defmacro info(message, category) do
    source = get_source(__CALLER__)

    quote bind_quoted: [message: message, category: category, source: source] do
      require Logger
      Logger.info(message)

      Elixir.Sentry.Context.add_breadcrumb(
        category: category,
        message: message,
        data: %{source: source},
        level: "info"
      )
    end
  end

  defmacro warn(message, category) do
    source = get_source(__CALLER__)

    quote bind_quoted: [message: message, category: category, source: source] do
      require Logger
      Logger.warn(message)

      Elixir.Sentry.Context.add_breadcrumb(
        category: category,
        message: message,
        data: %{source: source},
        level: "warning"
      )
    end
  end

  defmacro error(message, category) do
    source = get_source(__CALLER__)

    quote bind_quoted: [message: message, category: category, source: source] do
      require Logger
      Logger.error(message)

      Elixir.Sentry.Context.add_breadcrumb(
        category: category,
        message: message,
        data: %{source: source},
        level: "error"
      )
    end
  end
end
