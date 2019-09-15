defmodule Worker.Command.Misc.Avatar do
  use Worker.Command

  alias Worker.Resolver.User

  @impl true
  def description(), do: Template.avatar_description()
  @impl true
  def usages(), do: Template.avatar_usages()
  @impl true
  def examples(), do: Template.avatar_examples()

  @impl true
  def triggers(), do: ["avatar"]
  @impl true
  def required(), do: [MiddleWare.FetchGuild]

  @impl true
  def call(%{args: []} = command, _) do
    set_response(command, content: Template.generic_no_args())
  end

  def call(%{args: [user | _], assigns: %{guild: guild}} = command, _) do
    response =
      case User.resolve(user, guild) do
        nil ->
          [content: Template.generic_no_user(user)]

        user ->
          {avatar, extension} = fetch_avatar(user)

          [
            embed: %{
              title: "#{user.username}##{user.discriminator} (#{user.id})",
              image: %{
                url: "attachment://avatar.#{extension}"
              }
            },
            files: [{avatar, "avatar.#{extension}"}]
          ]
      end

    set_response(command, response)
  end

  defp fetch_avatar(user, first \\ true)

  defp fetch_avatar(%{avatar: nil} = user, _) do
    %{status_code: 200, body: avatar} =
      Crux.Rest.CDN.default_user_avatar(user)
      |> Util.Rest.get!()

    {avatar, "png"}
  end

  defp fetch_avatar(%{avatar: avatar} = user, true) do
    extension =
      if match?("a_" <> _, avatar) do
        "gif"
      else
        "webp"
      end

    url = Crux.Rest.CDN.user_avatar(user, size: 2048)

    case Util.Rest.get!(url) do
      %{body: avatar} ->
        {avatar, extension}

      %HTTPoison.Response{status_code: 404} ->
        # Outdated user, delete
        Rpc.Cache.delete(User, user.id)

        Rest.get_user!(user.id)
        |> fetch_avatar(false)
    end
  end
end
