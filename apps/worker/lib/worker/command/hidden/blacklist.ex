defmodule Worker.Command.Hidden.Blacklist do
  use Worker.Command

  alias Worker.Config.Global

  @impl true
  def description(), do: :LOC_BLACKLIST_DESCRIPTION
  @impl true
  def usages(), do: :LOC_BLACKLIST_USAGES
  @impl true
  def examples(), do: :LOC_BLACKLIST_EXAMPLES

  @impl true
  def triggers(), do: ["blacklist"]
  @impl true
  def required(), do: [Worker.MiddleWare.OwnerOnly]

  @impl true
  def call(%{args: []} = command, _) do
    res =
      Global.get_blacklisted()
      |> Enum.join("\n")
      |> case do
        "" ->
          "Nobody and nothing blacklisted \\o/"

        ids ->
          """
          Currently blacklisted are:
          ```
          #{ids}
          ```
          """
      end

    set_response(command, content: res)
  end

  def call(%{args: [id]} = command, _) do
    res =
      case Global.blacklist(id, true) do
        :ok ->
          "Successfully blacklisted `#{id}`."

        :error ->
          "Blacklisting `#{id}` failed."
      end

    set_response(command, content: res)
  end

  def call(%{args: ["remove", id]} = command, _) do
    res =
      case Global.blacklist(id, false) do
        num when num > 0 ->
          "Removed `#{id}` successfully from the blacklist."

        num when num <= 0 ->
          "`#{id}` was not blacklisted."

        :error ->
          "An error occured while unblacklisting `#{id}`."
      end

    set_response(command, content: res)
  end
end
