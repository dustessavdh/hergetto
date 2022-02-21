defmodule Hergetto.Videos do
  @moduledoc false
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
    with true <- exists?(video_service),
         pid <- Process.whereis(generate_video_service_id(video_service)) do
      GenServer.cast(pid, {:add, video})
      :ok
    else
      _ ->
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
    with true <- exists?(video_service),
         pid <- Process.whereis(generate_video_service_id(video_service)) do
      GenServer.cast(pid, {:set_current, video})
      :ok
    else
      _ ->
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
    with true <- exists?(video_service),
         playlist <- get_playlist(video_service),
         true <- length(playlist) > 0 do
      new_video = List.last(playlist)
      video_service |> delete(length(playlist) - 1)
      video_service |> set_current(new_video)
      :ok
    else
      _ ->
        :error
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
    with true <- exists?(video_service),
         pid <- Process.whereis(generate_video_service_id(video_service)) do
      GenServer.cast(pid, {:delete, index})
      :ok
    else
      _ ->
        :novideoservice
    end
  end

  @doc """
  This function returns the state of a video service.

  ## Examples
      iex> {:ok, video_service} = Videos.create()
      {:ok, "3e9dd45a-2aae-4288-a2a1-69406bf0df2f"}
      iex> video_service |> Videos.get_all(:all)
      %{
        playlist: [
          %Hergetto.Structs.Video{name: nil, platform: nil, url: nil},
          %Hergetto.Structs.Video{name: nil, platform: nil, url: nil}
        ],
        video_service: "3e9dd45a-2aae-4288-a2a1-69406bf0df2f"
      }
  """
  def get(video_service, scope) do
    with true <- exists?(video_service),
         pid <- Process.whereis(generate_video_service_id(video_service)) do
      GenServer.call(pid, {:get, scope})
    else
      _ ->
        :novideoservice
    end
  end

  @doc false
  def get_all(video_service) do
    get(video_service, :all)
  end

  @doc false
  def get_playlist(video_service) do
    get(video_service, :playlist)
  end

  @doc false
  def get_current(video_service) do
    get(video_service, :current)
  end

  @doc """
  Check if the specified `video_service` exists?.

  Returns `true` or `false`.

  ## Examples

      iex> Videos.exists?("93a628cc-cec1-4733-b513-aff5824b02da")
      true

  """
  def exists?(video_service) do
    with state <- Process.whereis(generate_video_service_id(video_service)) do
      is_pid(state)
    end
  end

  @doc false
  defp generate_video_service_id(video_service) do
    :"video_service:#{video_service}"
  end
end
