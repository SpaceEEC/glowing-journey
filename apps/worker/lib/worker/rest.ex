defmodule Worker.Rest do
  @moduledoc false

  use HTTPoison.Base

  @user_agent "crispy-system (https://github.com/spaceeec/crispy-system.git)"

  def process_request_headers(headers) do
    headers
    |> Keyword.put_new(:"user-agent", @user_agent)
    |> Keyword.put_new(:accept, "application/json")
    |> Keyword.put_new(:"content-type", "application/json")
  end

  def process_request_body(""), do: ""
  def process_request_body({:multipart, _} = body), do: body
  def process_request_body(body), do: Poison.encode!(body)

  # Yes, Poison.decode/1 can fail!
  @dialyzer {:nowarn_function, process_response_body: 1}

  def process_response_body(body) when is_bitstring(body) do
    case Poison.decode(body) do
      {:error, _} -> body
      {:ok, res} -> res
    end
  end

  def process_response_body(body), do: body
end
