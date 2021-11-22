defmodule Hergetto.Videos do
  alias Hergetto.Videos.VideoSupervisor
  alias Hergetto.Videos.VideoService
  alias Hergetto.Helpers.ServiceStartHelper

  @doc """
  This function creates a new video service.

  Returns `{:ok, uuid}`. This `uuid` represents a video service.

  ## Examples

      iex> Videos.create()
      {:ok, "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"}

  """
  def create(room) do
    ServiceStartHelper.start(VideoSupervisor, VideoService, room)
  end

  @doc """
  This function adds a video to the specified video service.

  ## Examples

      iex> {:ok, video_service} = Videos.create()
      {:ok, "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"}
      iex> video_service |> Videos.add(%Video{})
      :ok

  """
  def add(video_service, video) do
    case video_service |> exists() do
      true ->
        pid = Process.whereis(video_service |> generate_videos_service())
        GenServer.cast(pid, {:add, video})
        :ok
      false ->
        :novideoservice
    end
  end

  @doc """
  This function sets the current video.

  ## Examples

      iex> {:ok, video_service} = Videos.create()
      {:ok, "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"}
      iex> video_service |> Videos.set(%Video{})
      :ok

  """
  def set_current(video_service, video) do
    case video_service |> exists() do
      true ->
        pid = Process.whereis(video_service |> generate_videos_service())
        GenServer.cast(pid, {:set_current, video})
        :ok
      false ->
        :novideoservice
    end
  end

  @doc """
  This function plays the next video from the playlist

  ## Examples

      iex> {:ok, video_service} = Videos.create()
      {:ok, "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"}
      iex> video_service |> Videos.add(%Video{})
      :ok
      iex> video_service |> Videos.next()
      :ok

  """
  def next(video_service) do
    case video_service |> exists() do
      true ->
        playlist = video_service |> get_playlist()
        case length(playlist) > 0 do
          true ->
            new_video = List.last(playlist)
            video_service |> delete(length(playlist) - 1)
            video_service |> set_current(new_video)
            :ok
          false ->
            :novideos
        end
      false ->
        :novideoservice
    end
  end

  @doc """
  This function deletes a video from the playlist.

  ## Examples

      iex> {:ok, video_service} = Videos.create()
      {:ok, "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"}
      iex> video_service |> Videos.add(%Video{})
      :ok

  """
  def delete(video_service, index) do
    case video_service |> exists() do
      true ->
        pid = Process.whereis(video_service |> generate_videos_service())
        GenServer.cast(pid, {:delete, index})
        :ok
      false ->
        :novideoservice
    end
  end

  @doc """
  This function returns the state of a video service.

  ## Examples
      iex> {:ok, video_service} = Videos.create()
      {:ok, "3e9dd45a-2aae-4288-a2a1-69406bf0df2f"}
      iex> video_service |> Videos.get(:all)
      %{
        playlist: [
          %Hergetto.Structs.Video{name: nil, platform: nil, url: nil},
          %Hergetto.Structs.Video{name: nil, platform: nil, url: nil}
        ],
        video_service: "3e9dd45a-2aae-4288-a2a1-69406bf0df2f"
      }
  """
  def get(video_service, scope) do
    case video_service |> exists() do
      true ->
        pid = Process.whereis(video_service |> generate_videos_service())
        GenServer.call(pid, {:get, scope})
      false ->
        {:error, :novideoservice}
    end
  end

  @doc false
  def get_all(video_service) do
    video_service |> get(:all)
  end

  @doc false
  def get_playlist(video_service) do
    video_service |> get(:playlist)
  end

  @doc false
  def get_current(video_service) do
    video_service |> get(:current)
  end

  @doc """
  Check if the specified `video_service` exists.

  Returns `true` or `false`.

  ## Examples

      iex> Videos.exists("93a628cc-cec1-4733-b513-aff5824b02da")
      true

  """
  def exists(video_service) do
    case Process.whereis(video_service |> generate_videos_service()) do
      nil ->
        false
      _ ->
        true
    end
  end

  @doc false
  defp generate_videos_service(video_service) do
    :"video_service:#{video_service}"
  end
end
