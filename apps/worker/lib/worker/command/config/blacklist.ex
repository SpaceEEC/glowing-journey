defmodule Worker.Command.Config.Blacklist do
  use Worker.Command

  alias Crux.Structs.Permissions

  alias Util.Config.Guild
  alias Worker.Resolver.User

  @impl true
  def description(), do: Template.blacklist_description()
  @impl true
  def usages(), do: Template.blacklist_usages()
  @impl true
  def examples(), do: Template.blacklist_examples()

  @impl true
  def triggers(), do: ["blacklist"]

  @impl true
  def required() do
    [
      MiddleWare.GuildOnly,
      MiddleWare.FetchGuild,
      {MiddleWare.HasPermissions, {:manage_guild, nil, :member}},
      {MiddleWare.HasPermissions, {:embed_links, nil, :self}}
    ]
  end

  @impl true
  def call(%{args: []} = command, _) do
    blacklisted =
      Guild.get_blacklisted(command)
      |> Enum.map_join(">, <@", & &1)
      |> String.slice(0..2047)
      |> case do
        "" ->
          Template.blacklist_nobody_blacklisted()

        blacklsited ->
          "<@#{blacklsited}>"
      end

    embed = %{
      title: Template.blacklist_embed_title(),
      description: blacklisted
    }

    set_response(command, embed: embed)
  end

  def call(%{args: [user], assigns: %{guild: guild}, message: %{author: author}} = command, _) do
    content = blacklist(user, guild, true, author.id)

    set_response(command, content: content)
  end

  def call(
        %{
          args: [maybe_add_or_remove, maybe_user | _],
          assigns: %{guild: guild},
          message: %{author: author}
        } = command,
        _
      ) do
    content =
      case String.downcase(maybe_add_or_remove) do
        "remove" ->
          blacklist(maybe_user, guild, false, author.id)

        "add" ->
          blacklist(maybe_user, guild, true, author.id)

        _other ->
          blacklist(maybe_add_or_remove, guild, true, author.id)
      end

    set_response(command, content: content)
  end

  defp blacklist(user, guild, blacklist, author_id) do
    case User.resolve(user, guild) do
      nil ->
        Template.generic_no_user(user)

      %{bot: true} ->
        Template.blacklist_bot()

      %{id: ^author_id} ->
        Template.blacklist_self()

      user ->
        member = guild.members[user.id] || Rest.get_guild_member!(guild, user)

        # Ignore permissions check if you remove
        if blacklist and Permissions.implicit(member, guild) |> Permissions.has(:manage_guild) do
          Template.blacklist_priviliged()
        else
          case Guild.blacklist(guild, user, blacklist) do
            :ok ->
              Template.blacklist_blacklisted("#{user.username}##{user.discriminator}")

            1 ->
              Template.blacklist_unblacklisted("#{user.username}##{user.discriminator}")

            0 ->
              Template.blacklist_not_blacklisted("#{user.username}##{user.discriminator}")
          end
        end
    end
  end
end
