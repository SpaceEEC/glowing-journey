defmodule Util do
  @moduledoc """
  Documentation for Util.
  """

  defguardp is_id(id) when is_binary(id) or is_integer(id) or is_nil(id)

  @doc """
    Resolves a given term to a guild id.
  """
  @spec resolve_guild_id(Command.t() | Message.t() | Crux.Rest.snowflake()) ::
          Crux.Rest.snowflake()

  # Command.t()
  def resolve_guild_id(%{message: message}), do: resolve_guild_id(message)
  # Message.t()
  def resolve_guild_id(%{guild_id: guild_id}), do: resolve_guild_id(guild_id)
  # Guild.t()
  def resolve_guild_id(%{id: guild_id}), do: resolve_guild_id(guild_id)
  # Snowflake.t()
  def resolve_guild_id(guild_id) when is_id(guild_id), do: guild_id

  def resolve_guild_id!(guild) do
    case resolve_guild_id(guild) do
      nil -> raise "Could not resolve #{guild} to a guild id!"
      guild_id -> guild_id
    end
  end

  @doc """
    Resolves a given term to a user id.
  """
  @spec resolve_user_id(Command.t() | Message.t() | User.t() | Crux.Rest.snowflake()) ::
          Crux.Rest.snowflake()
  # Command.t()
  def resolve_user_id(%{message: message}), do: resolve_user_id(message)
  # Message.t()
  def resolve_user_id(%{author: user}), do: resolve_user_id(user)
  # Member.t()
  def resolve_user_id(%{user: user_id}), do: resolve_user_id(user_id)
  # User.t()
  def resolve_user_id(%{id: user_id}), do: resolve_user_id(user_id)
  # Snowflake.t()
  def resolve_user_id(user_id) when is_id(user_id), do: user_id

  def resolve_user_id!(user) do
    case resolve_user_id(user) do
      nil -> raise "Could not resolve #{user} to a user id!"
      user_id -> user_id
    end
  end
end
