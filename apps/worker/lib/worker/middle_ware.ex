defmodule Worker.MiddleWare do
  defmacro __using__(_ \\ []) do
    quote do
      use Crux.Extensions.Command
      alias Worker.MiddleWare
      alias Rpc.{Cache, Rest}
    end
  end
end
