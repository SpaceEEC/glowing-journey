defmodule Worker.Command.Music.Seek do
  use Worker.Command

  alias Rpc.LavaLink

  @impl true
  def description(), do: Template.seek_description()
  @impl true
  def usages(), do: Template.seek_usages()
  @impl true
  def examples(), do: Template.seek_examples()

  @impl true
  def triggers(), do: ["seek"]

  @impl true
  def required(),
    do: [
      MiddleWare.GuildOnly,
      {MiddleWare.Connected, :seek},
      {MiddleWare.DJ, &MiddleWare.OwnerOnly.owner?/1}
    ]

  @impl true
  def call(%{args: []} = command, _) do
    set_response(command, Template.generic_no_args())
  end

  def call(%{args: [position | _], message: %{guild_id: guild_id}} = command, _) do
    content =
      with {:ok, position} <- parse_position(position),
           :ok <- LavaLink.seek(guild_id, position * 1000) do
        Template.seek_seeking()
      else
        {:error, :empty} ->
          Template.seek_empty()

        {:error, :not_seekable} ->
          Template.seek_not_seekable()

        {:error, :out_of_bounds} ->
          Template.seek_out_of_bounds()

        {:error, response} ->
          response
      end

    set_response(command, content: content)
  end

  defp parse_position(position) do
    with {position, ""} when position >= 0 <- Integer.parse(position) do
      {:ok, position}
    else
      _ ->
        case Regex.run(~r{^(?:(\d+):)?([0-5]?\d):([0-5]?\d)}, position) do
          nil ->
            {:error, Template.seek_nan()}

          [_, "", minutes, seconds] ->
            position = String.to_integer(minutes) * 60 + String.to_integer(seconds)

            {:ok, position}

          [_, hours, minutes, seconds] ->
            position =
              String.to_integer(hours) * 60 * 60 + String.to_integer(minutes) * 60 +
                String.to_integer(seconds)

            {:ok, position}
        end
    end
  end
end
