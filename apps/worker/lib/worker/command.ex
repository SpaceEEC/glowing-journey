defmodule Worker.Command do
  defmacro __using__(_ \\ []) do
    quote do
      use Crux.Extensions.Command
      alias Worker.MiddleWare
      alias Rpc.{Cache, Rest}

      alias Util.Locale.Template

      @behaviour unquote(__MODULE__)
    end
  end

  @callback description() :: Util.Locale.localizable()
  @callback usages() :: Util.Locale.localizable()
  @callback examples() :: Util.Locale.localizable()
end
