defmodule Worker.Config.Etcd do
  @moduledoc """
    Config provider using [`etcd`](https://github.com/etcd-io/etcd) as backing.

    Using the [`kv`](https://github.com/etcd-io/etcd/blob/master/Documentation/dev-guide/api_reference_v3.md#service-kv-etcdserveretcdserverpbrpcproto) service.
  """

  alias Worker.Rest

  @base_url Application.fetch_env!(:worker, :etcd_base_url)

  @doc """
    Gets a value via key.
  """
  @spec get(key :: String.t(), default :: term()) :: String.t() | term()
  def get(key, default \\ nil) when is_binary(key) do
    case request("/range", key: key) do
      {:error, _error} ->
        # TODO: return :error?
        default

      {:ok, %{"kvs" => [%{"value" => value}]}} ->
        Base.decode64!(value)

      {:ok, _} ->
        default
    end
  end

  @doc """
    Gets a range of key-value pairs using a prefix.
  """
  @spec range_prefix(prefix :: String.t()) :: %{String.t() => String.t()}
  def range_prefix(prefix) when is_binary(prefix) do
    prefix_end = Regex.replace(~r{(.$)}, prefix, fn <<char>> -> <<char + 1>> end)
    range(prefix, prefix_end)
  end

  @doc """
    Gets a range of key-value pairs.
    Range is defined as: `[key, range)`
  """
  @spec range(key :: String.t(), range_end :: String.t()) :: %{String.t() => String.t()}
  def range(key, range_end) when is_binary(key) and is_binary(range_end) do
    case request("/range", key: key, range_end: range_end) do
      {:error, _error} ->
        :error

      {:ok, %{"kvs" => kvs}} ->
        for %{"key" => key, "value" => value} <- kvs, into: %{} do
          {Base.decode64!(key), Base.decode64!(value)}
        end

      {:ok, _} ->
        %{}
    end
  end

  @doc """
    Sets a key-value pair
  """
  @spec put(key :: String.t(), value :: String.t()) :: :ok | :error
  def put(key, value) when is_binary(key) and is_binary(value) do
    case request("/put", key: key, value: value) do
      {:ok, _body} ->
        :ok

      {:error, _error} ->
        :error
    end
  end

  @doc """
    Deletes a key-value pair by key.
  """
  @spec delete(key :: String.t()) :: non_neg_integer() | :error
  def delete(key) when is_binary(key) do
    case request("/deleterange", key: key) do
      {:ok, %{"deleted" => deleted}} ->
        String.to_integer(deleted)

      {:ok, _body} ->
        0

      {:error, _error} ->
        :error
    end
  end

  @spec request(
          route :: String.t(),
          data :: [{atom(), String.t()}]
        ) :: {:ok, map()} | {:error, term()}
  defp request(route, data) do
    data = Map.new(data, fn {k, v} -> {k, Base.encode64(v)} end)

    Rest.post(@base_url <> route, data)
    |> case do
      {:ok, %{body: body}} ->
        {:ok, body}

      {:error, error} ->
        require Logger

        Logger.error(fn ->
          """
          Route: #{route}
          Data : #{inspect(data)}
          Error: #{inspect(error)}
          """
        end)

        {:error, error}
    end
  end
end
