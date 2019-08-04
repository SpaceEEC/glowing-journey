defmodule Worker.Command.Hidden.Eval do
  use Worker.Command

  @impl true
  def description(), do: :LOC_EVAL_DESCRIPTION
  @impl true
  def usages(), do: :LOC_EVAL_USAGES
  @impl true
  def examples(), do: :LOC_EVAL_EXAMPLES

  @impl true
  def triggers(), do: ["eval"]
  @impl true
  def required(), do: [MiddleWare.OwnerOnly]

  @impl true
  def call(%{args: args, message: message} = command, _opts) do
    # Paranoid
    true = MiddleWare.OwnerOnly.owner?(command)

    {res, _binding} =
      try do
        args
        |> Enum.join(" ")
        |> Code.eval_string(
          [message: message],
          aliases: [{Elixir.Rest, Rpc.Rest}, {Elixir.Cache, Rpc.Cache}, {Structs, Crux.Structs}]
        )
      rescue
        e -> {Exception.format(:error, e, __STACKTRACE__), nil}
      end

    res =
      if(is_bitstring(res), do: res, else: inspect(res))
      |> String.slice(0, 1950)

    command
    |> set_response(content: "```elixir\n#{res}\n```")
  end
end
