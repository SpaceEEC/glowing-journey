defmodule Rpc.LavaLink.Track do
  use Rpc, :lavalink

  def to_embed(track, type) when is_local() do
    LavaLink.Track.to_embed(track, type)
  end

  def to_embed(track, type) do
    do_rpc()
  end

  def to_length(track) when is_local() do
    LavaLink.Track.to_length(track)
  end

  def to_length(track) do
    do_rpc()
  end

  def to_markdown_uri(track) when is_local() do
    LavaLink.Track.to_markdown_uri(track)
  end

  def to_markdown_uri(track) do
    do_rpc()
  end

  def format_milliseconds(millis) when is_local() do
    LavaLink.Track.format_milliseconds(millis)
  end

  def format_milliseconds(millis) do
    do_rpc()
  end
end
