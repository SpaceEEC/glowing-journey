defmodule Worker.Command.Misc.Invite do
  @moduledoc false

  use Worker.Command

  @invite_url "https://discordapp.com/oauth2/authorize?client_id={{id}}&scope=bot&permissions={{permissions}}"

  alias Crux.Structs.Permissions

  @impl true
  def description(), do: :LOC_INVITE_DESCRIPTION
  @impl true
  def usages(), do: :LOC_INVITE_USAGES
  @impl true
  def examples(), do: :LOC_INVITE_EXAMPLES

  @impl true
  def triggers(), do: ["invite"]

  @impl true
  def call(command, _opts) do
    permissions =
      [
        :view_channel,
        :send_messages,
        # :manage_messages,
        :embed_links,
        # :attach_files,
        # :external_emojis,
        # :add_reactions,
        :connect,
        :speak
      ]
      |> Permissions.resolve()
      |> to_string()

    id =
      Worker.Commands.get_user_id()
      |> to_string()

    url =
      @invite_url
      |> String.replace("{{id}}", id)
      |> String.replace("{{permissions}}", permissions)

    embed = %{
      author: %{
        name: :LOC_INVITE,
        url: url
      },
      description: {:LOC_INVITE_EMBED_DESCRIPTION, [url: url]}
    }

    command
    |> set_response(embed: embed)
  end
end
