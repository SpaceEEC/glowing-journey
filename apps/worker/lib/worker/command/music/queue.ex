defmodule Worker.Command.Music.Queue do
  use Worker.Command

  alias Rpc.LavaLink
  alias Rpc.LavaLink.Track
  alias Worker.Command.Music.NowPlaying

  @impl true
  def description(), do: :LOC_QUEUE_DESCRIPTION
  @impl true
  def usages(), do: :LOC_QUEUE_USAGES
  @impl true
  def examples(), do: :LOC_QUEUE_EXAMPLES

  @impl true
  def triggers(), do: ["queue", "q"]
  @impl true
  def required(), do: [MiddleWare.GuildOnly, {MiddleWare.Connected, :queue}]

  @impl true
  def call(%{args: []} = command, _) do
    queue(1, command)
  end

  def call(%{args: [page | _]} = command, _) do
    case Integer.parse(page) do
      {page, ""} when page > 0 ->
        queue(page, command)

      {_page, ""} ->
        set_response(command, content: :LOC_QUEUE_LESS_THAN_ONE)

      _ ->
        set_response(command, content: :LOC_QUEUE_NAN)
    end
  end

  def queue(page, %{message: %{guild_id: guild_id}} = command)
      when page > 0 do
    case LavaLink.queue(guild_id) do
      [_current] ->
        NowPlaying.call(command, [])

      [current | queue_tracks] ->
        queue_length = Enum.count(queue_tracks)

        queue_time =
          queue_tracks
          |> Enum.reduce(0, fn %{length: length}, acc -> length + acc end)
          |> Track.format_milliseconds()

        max_page = ceil(queue_length / 10)
        page = min(page, max_page)
        start = (page - 1) * 10

        queue_string =
          queue_tracks
          |> Enum.slice(start, 10)
          |> Enum.with_index(start + 1)
          |> Enum.map_join("\n", fn {track, index} ->
            name = Track.to_markdown_uri(track)
            length = Track.to_length(track)

            "`#{index}.` #{length} - #{name}"
          end)

        ### don't look

        embed =
          current
          |> Track.to_embed(:now_playing)
          |> Map.merge(
            %{
              title:
                {:LOC_QUEUE_EMBED_TITLE,
                 queue_length: to_string(queue_length), queue_time: queue_time},
              description: queue_string,
              footer: %{
                text: {:LOC_QUEUE_PAGES, page: to_string(page), max_page: to_string(max_page)}
              }
            },
            fn
              :description, current, ^queue_string ->
                {:LOC_QUEUE_EMBED_DESCRIPTION, current: current, queue: queue_string}

              :footer, old, %{text: text} ->
                %{old | text: text}
            end
          )
          |> Map.delete(:author)

        {image, embed} = Map.pop(embed, :image)
        embed = Map.put(embed, :thumbnail, image)

        ### look again

        set_response(command, embed: embed)
    end
  end
end
