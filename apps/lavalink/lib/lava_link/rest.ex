defmodule LavaLink.Rest do
  alias LavaLink.Track

  defp url() do
    "http://" <> Application.fetch_env!(:lavalink, :lavalink_authority) <> "/loadtracks"
  end

  defp authorization() do
    Application.fetch_env!(:lavalink, :lavalink_authorization)
  end

  def resolve_identifier("scsearch:" <> _ = identifier) do
    identifier
  end

  def resolve_identifier("ytsearch:" <> _ = identifier) do
    identifier
  end

  def resolve_identifier("http://" <> _ = url) do
    url
  end

  def resolve_identifier("https://" <> _ = url) do
    url
  end

  def resolve_identifier("<" <> _ = identifier)
      when binary_part(identifier, byte_size(identifier) - 1, 1) == ">" do
    identifier
    |> binary_part(1, byte_size(identifier) - 2)
    |> resolve_identifier()
  end

  def resolve_identifier(other) do
    "ytsearch:#{other}"
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
         %{
           "loadType" => "SEARCH_RESULT",
           "tracks" => []
         },
         _requester
       ) do
    []
  end

  defp handle_response(
         %{"loadType" => "LOAD_FAILED"} = response,
         _requester
       ) do
    require Rpc.Sentry
    Rpc.Sentry.error("Fetching failed #{inspect(response)}", "handler")

    Sentry.capture_message("Fetching tracks failed.")

    []
  end

  defp handle_response(
         %{"loadType" => "NO_MATCHES"},
         _requester
       ) do
    []
  end
end
