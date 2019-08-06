defmodule Worker.Command.Hidden.Blacklist do
  use Worker.Command

  alias Util.Config.Global

  @impl true
  def description(), do: "The global blacklist."
  @impl true
  def usages(), do: "Usage: `hiddenblacklist [remove] [UserID|GuildID]`"
  @impl true
  def examples(), do: "Example: `hiddenblacklist`"

  @impl true
  def triggers(), do: ["globalblacklist"]
  @impl true
  def required(), do: [Worker.MiddleWare.OwnerOnly]

  @impl true
  def call(%{args: []} = command, _) do
    res =
      Global.get_blacklisted()
      |> Enum.join(", ")
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
        1 ->
          "Removed `#{id}` successfully from the blacklist."

        0 ->
          "`#{id}` was not blacklisted."

        :error ->
          "An error occured while unblacklisting `#{id}`."
      end

    set_response(command, content: res)
  end
end
