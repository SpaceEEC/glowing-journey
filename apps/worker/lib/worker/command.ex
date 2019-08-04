defmodule Worker.Command do
  defmacro __using__(_ \\ []) do
    quote do
      use Crux.Extensions.Command
      alias Worker.MiddleWare
      alias Rpc.{Cache, Rest}

      @behaviour unquote(__MODULE__)
    end
  end

  @callback description() :: Worker.Locale.localizable()
  @callback usages() :: Worker.Locale.localizable()
  @callback examples() :: Worker.Locale.localizable()
end
