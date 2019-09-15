defmodule Worker.Command.Misc.Invite do
  @moduledoc false

  use Worker.Command

  @invite_url "https://discordapp.com/oauth2/authorize?client_id={{id}}&scope=bot&permissions={{permissions}}"

  alias Crux.Structs.Permissions

  @impl true
  def description(), do: Template.invite_description()
  @impl true
  def usages(), do: Template.invite_usages()
  @impl true
  def examples(), do: Template.invite_examples()

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
        name: Template.invite(),
        url: url
      },
      description: Template.invite_embed_description(url)
    }

    command
    |> set_response(embed: embed)
  end
end
