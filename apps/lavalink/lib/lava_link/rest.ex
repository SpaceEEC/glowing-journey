defmodule LavaLink.Rest do
  alias LavaLink.Track

  require Logger

  defp url() do
    "http://" <> Application.fetch_env!(:lavalink, :lavalink_authority) <> "/loadtracks"
  end


  defp authorization() do
    Application.fetch_env!(:lavalink, :lavalink_authorization)
  end

  def resolve_identifier(url) do
    # Strip <> to avoid embeds in Discord
    [_, url] = Regex.run(~r{^<?(.+?)>?$}, url)

    if Regex.match?(~r{^https?://}, url) do
      url
    else
      "ytsearch:#{url}"
    end
  end

  def fetch_tracks(identifier, requester) do
    url()
    |> HTTPoison.get(
      [{"Authorization", authorization()}],
      params: [identifier: identifier]
    )
    |> case do
      {:error, _error} = tuple ->
        tuple

      {:ok, %{body: body}} ->
        body
        |> Jason.decode()
        |> handle_response(requester)
    end
  end

  defp handle_response({:ok, response}, requester), do: handle_response(response, requester)
  defp handle_response({:error, _error} = tuple, _requester), do: tuple

  defp handle_response(
         %{
           "loadType" => "TRACK_LOADED",
           "tracks" => [track | _]
         },
         requester
       ) do
    Track.create(track, requester)
  end

  defp handle_response(
         %{
           "loadType" => "PLAYLIST_LOADED",
           "playlistInfo" => %{"selectedTrack" => -1},
           "tracks" => tracks
         },
         requester
       ) do
    Track.create(tracks, requester)
  end

  defp handle_response(
         %{
           "loadType" => "PLAYLIST_LOADED",
           "playlistInfo" => %{"selectedTrack" => slected_track},
           "tracks" => tracks
         },
         requester
       ) do
    tracks
    |> Enum.at(slected_track)
    |> Track.create(requester)
  end

  defp handle_response(
         %{
           "loadType" => "SEARCH_RESULT",
           "tracks" => [track | _]
         },
         requester
       ) do
    Track.create(track, requester)
  end

  defp handle_response(
         %{"loadType" => "LOAD_FAILED"} = response,
         _requester
       ) do
    Logger.error(fn -> "Fetching failed #{inspect(response)}" end)

    []
  end

  defp handle_response(
         %{"loadType" => "NO_MATCHES"},
         _requester
       ) do
    []
  end
end
