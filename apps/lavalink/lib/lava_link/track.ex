defmodule LavaLink.Track do
  defstruct [
    :track,
    :author,
    :identifier,
    :is_seekable,
    :is_stream,
    :length,
    :position,
    :title,
    :uri,
    :requester
  ]

  alias Rpc.Cache
  alias Crux.Rest.CDN
  alias Util.Locale.Template

  @type t :: %__MODULE__{}

  @spec create(map | [map], Crux.Structs.User.t()) :: [LavaLink.Track.t() | [LavaLink.Track.t()]]
  def create(tracks, requester) when is_list(tracks) do
    Enum.map(tracks, &create(&1, requester))
  end

  def create(
        %{
          "info" => info,
          "track" => track
        },
        requester
      ) do
    data =
      info
      |> Map.new(fn {k, v} -> {k |> Macro.underscore() |> String.to_atom(), v} end)
      |> Map.merge(%{
        track: track,
        requester: requester
      })

    struct(__MODULE__, data)
  end

  # :end
  # :pause
  # :play
  # :save
  # :add
  # :now_playing
  @spec to_embed(t(), type :: atom()) :: Crux.Rest.embed()
  def to_embed(
        %__MODULE__{
          requester: %{username: username, discriminator: discriminator, id: id} = requester
        } = track,
        type \\ nil
      ) do
    %{
      author: %{
        name: "#{username}##{discriminator} (#{id})",
        icon_url: CDN.user_avatar(requester)
      },
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601(),
      image: %{
        url: to_image_uri(track)
      }
    }
    |> Map.merge(type_data(type, track))
    |> put_in([:footer, :icon_url], CDN.user_avatar(Cache.me!()))
  end

  @spec to_markdown_uri(LavaLink.Track.t()) :: String.t()
  def to_markdown_uri(%__MODULE__{title: title, uri: uri}) do
    title = String.replace(title, ~r/[\[\]]/, "")
    "[#{title}](#{uri})"
  end

  @spec to_length(LavaLink.Track.t()) :: Util.Locale.localizable()
  def to_length(%__MODULE__{length: length}), do: format_milliseconds(length)

  @spec to_info(LavaLink.Track.t()) :: Util.Locale.localizable()
  def to_info(track, type \\ nil)

  def to_info(%__MODULE__{} = track, :now_playing) do
    Template.track_position(
      to_markdown_uri(track),
      format_milliseconds(track.position),
      to_length(track)
    )
  end

  def to_info(%__MODULE__{} = track, _) do
    Template.track_info(to_markdown_uri(track), to_length(track))
  end

  defp type_data(nil, track), do: %{description: to_markdown_uri(track)}

  defp type_data(:save, track) do
    %{
      # aqua
      color: 0x7EB7E4,
      description: Template.track_description("💾", to_info(track)),
      footer: %{
        text: Template.track_save()
      }
    }
  end

  defp type_data(:play, track) do
    %{
      # green
      color: 0x00FF08,
      description: Template.track_description("**>>**", to_info(track)),
      footer: %{
        text: Template.track_play()
      }
    }
  end

  defp type_data(:add, track) do
    %{
      # yellow
      color: 0xFFFF00,
      description: Template.track_description("**++**", to_info(track)),
      footer: %{
        text: Template.track_add()
      }
    }
  end

  defp type_data(:now_playing, track) do
    %{
      # dark blue
      color: 0x0800FF,
      description: Template.track_description("**>>**", to_info(track, :now_playing)),
      footer: %{
        text: Template.track_now_playing()
      }
    }
  end

  defp type_data(:end, track) do
    %{
      # red
      color: 0xFF0000,
      description: Template.track_description("**--**", to_info(track)),
      footer: %{
        text: Template.track_end()
      }
    }
  end

  defp type_data(:pause, track) do
    %{
      # grey
      color: 0x7F8C8D,
      description: Template.track_description("**||**", to_info(track)),
      footer: %{
        text: Template.track_pause()
      }
    }
  end

  @spec to_image_uri(t()) :: String.t() | nil
  def to_image_uri(%{uri: "https://www.youtube.com/watch?v=" <> _id} = track) do
    "https://img.youtube.com/vi/#{track.identifier}/mqdefault.jpg"
  end

  def to_image_uri(%{uri: "https://twitch.tv/" <> _channel} = track) do
    "https://static-cdn.jtvnw.net/previews-ttv/live_user_#{String.downcase(track.author)}-320x180.jpg"
  end

  # Soundcloud, why do you not offer a url scheme? :c
  def to_image_uri(_other), do: nil

  @spec format_milliseconds(integer()) :: String.t()
  def format_milliseconds(time), do: time |> div(1000) |> format_seconds()

  @spec format_seconds(integer()) :: String.t()
  def format_seconds(time) when time > 86_400 do
    rest =
      time
      |> rem(86_400)
      |> format_seconds()

    Template.track_length_days(div(time, 86_400), rest)
  end

  def format_seconds(time) when time > 3_600 do
    rest =
      time
      |> rem(3_600)
      |> format_seconds()

    "#{div(time, 3_600)}:#{rest}"
  end

  def format_seconds(time) do
    seconds =
      time
      |> rem(60)
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    minutes =
      time
      |> div(60)
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    "#{minutes}:#{seconds}"
  end

  defimpl String.Chars, for: LavaLink.Track do
    alias LavaLink.Track
    @spec to_string(Track.t()) :: String.t()
    def to_string(%Track{} = data), do: Track.to_info(data)
  end
end
