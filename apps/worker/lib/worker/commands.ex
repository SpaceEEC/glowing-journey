defmodule Worker.Commands.Helper do
  def commands_to_map(commands) do
    list =
      for command <- commands, trigger <- command.triggers() do
        {trigger, command}
      end

    map = Map.new(list)

    # TODO: I want this check, but there probably is a better solution
    if map_size(map) != length(list) do
      raise "error"
    end

    map
  end
end

defmodule Worker.Commands do
  alias Worker.Command
  alias Util.Config.{Global, Guild}
  alias Util.Locale

  @commands [
    Command.Config.Blacklist,
    Command.Config.ConfigStatus,
    Command.Config,
    Command.Config.Locale,
    Command.Config.Prefix,
    Command.Hidden.Blacklist,
    Command.Hidden.Channel,
    Command.Hidden.Channels,
    Command.Hidden.Eval,
    Command.Hidden.Member,
    Command.Hidden.Role,
    Command.Hidden.User,
    Command.Misc.Help,
    Command.Misc.Info,
    Command.Misc.Invite,
    Command.Misc.Ping,
    Command.Misc.Uptime,
    Command.Music.Loop,
    Command.Music.NowPlaying,
    Command.Music.Pause,
    Command.Music.Play,
    Command.Music.Queue,
    Command.Music.Remove,
    Command.Music.Resume,
    Command.Music.Save,
    Command.Music.Shuffle,
    Command.Music.Skip,
    Command.Music.Stop,
    Command.Music.Summon,
    Command.Music.Volume
  ]

  @command_map Worker.Commands.Helper.commands_to_map(@commands)

  def get_command_groups(), do: @commands |> Enum.group_by(&:lists.nth(3, Module.split(&1)))
  def get_command_map(), do: @command_map

  def get_user_id(), do: Application.fetch_env!(:worker, :user_id)

  def get_default_prefix(), do: Application.fetch_env!(:worker, :default_prefix)

  if Mix.env() == :prod do
    defp mention_prefixes() do
      [
        "<@#{Application.fetch_env!(:worker, :user_id)}>",
        "<@!#{Application.fetch_env!(:worker, :user_id)}>"
      ]
    end
  else
    defp mention_prefixes() do
      []
    end
  end

  def get_owners(), do: Application.fetch_env!(:worker, :owners)

  def handle(message, shard_id) do
    require Logger

    Sentry.Context.set_user_context(%{
      user_id: message.author.id,
      guild_id: message.guild_id,
      channel_id: message.channel_id,
      content: message.content
    })

    Sentry.Context.set_tags_context(%{
      shard_id: shard_id
    })

    # Logger.info("handling message from #{message.author.username}: #{message.content}")

    prefixes = get_prefixes(message)

    # Logger.info("fetched prefixes: #{inspect(prefixes)}")

    command = get_command(message, prefixes, shard_id)

    # Logger.info("found command #{inspect(command, limit: 3)}")

    command =
      if message.author.id not in get_owners() do
        check_blacklists(command)
      else
        command
      end

    # Logger.info("blacklisted #{inspect(command, limit: 2)}")

    result =
      try do
        run_command(command)
      rescue
        error ->
          {:ok, mod, _command} = command

          Sentry.capture_exception(
            error,
            stacktrace: __STACKTRACE__,
            tags: %{
              command: mod.triggers() |> List.first()
            }
          )

          {:error, error, __STACKTRACE__}
      end

    send_response(result, message)
  end

  defp get_prefixes(%{guild_id: nil}), do: [get_default_prefix() | mention_prefixes()] ++ [""]

  defp get_prefixes(message) do
    guild_prefix = Guild.get_prefix(message.guild_id, get_default_prefix())

    [guild_prefix | mention_prefixes()]
  end

  defp get_command(%{content: content} = message, prefixes, shard_id) do
    case Enum.find_value(prefixes, &split_prefix(content, &1)) do
      nil ->
        {:error, :no_prefix}

      {_prefix, command, args} ->
        case @command_map do
          %{^command => mod} ->
            command = %Crux.Extensions.Command{
              args: args,
              message: message,
              response_channel: message.channel_id,
              shard_id: shard_id,
              trigger: command
            }

            {:ok, mod, command}

          _ ->
            {:error, {:no_command, command}}
        end
    end
  end

  defp split_prefix(content, prefix) do
    case String.split(content, prefix, parts: 2) do
      ["", content] ->
        require Logger
        Logger.info("found content: '#{content}'")

        [command | args] =
          content
          |> String.trim_leading()
          |> String.split(~r{ +})

        command = String.downcase(command)

        Logger.info("found possible command: '#{command}'")

        {prefix, command, args}

      _ ->
        nil
    end
  end

  defp check_blacklists({:error, _} = error), do: error

  defp check_blacklists(
         {:ok, _mod, %{message: %{guild_id: guild_id, author: %{id: user_id}}}} = tuple
       ) do
    cond do
      Global.blacklisted?(user_id) ->
        {:error, {:blacklist, :global_user}}

      Global.blacklisted?(guild_id) ->
        {:error, {:blacklist, :global_guild}}

      Guild.blacklisted?(guild_id, user_id) ->
        {:error, {:blacklist, :local_guild}}

      true ->
        tuple
    end
  end

  defp run_command({:error, _} = error), do: error
  defp run_command({:ok, mod, command}), do: run_command(mod, command)

  defp run_command(_command_mod, %Crux.Extensions.Command{halted: true} = command), do: command

  defp run_command(command_mod, %Crux.Extensions.Command{} = command) when is_atom(command_mod) do
    run_command({command_mod, []}, command)
  end

  defp run_command({command_mod, command_arg}, %Crux.Extensions.Command{} = command) do
    Code.ensure_loaded(command_mod)

    if function_exported?(command_mod, :required, 0) do
      Enum.reduce(command_mod.required(), command, &run_command/2)
    else
      command
    end
    |> case do
      %{halted: true} = command ->
        command

      command ->
        command_mod.call(command, command_arg)
    end
  end

  defp send_response({:error, :no_prefix}, _message), do: nil
  defp send_response({:error, {:no_command, _command}}, _message), do: nil

  defp send_response({:error, {:blacklist, _type}}, _message), do: nil

  defp send_response({:error, error, stacktrace}, message) do
    IO.inspect(error)
    IO.inspect(stacktrace)
    e = Exception.format_banner(:error, error, stacktrace)

    content = """
    An error occured
    ```elixir
    #{e}
    ```
    """

    Rpc.Rest.create_message!(message, content: content)
  end

  defp send_response(
         %Crux.Extensions.Command{
           response: response,
           response_channel: response_channel
         },
         _message
       )
       when is_nil(response)
       when is_nil(response_channel) do
    nil
  end

  defp send_response(
         %Crux.Extensions.Command{
           response: response,
           response_channel: response_channel,
           message: message
         },
         _message
       ) do
    locale = Locale.fetch!(message)
    response = Locale.localize_response(response, locale)

    Rpc.Rest.create_message!(response_channel, response)
  end
end
