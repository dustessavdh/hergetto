defmodule Hergetto.VideosTest do
  use ExUnit.Case
  alias Hergetto.Videos
  alias Hergetto.Structs.Video

  test "creates a video service" do
    {:ok, video_service} = Videos.create()
    assert video_service != nil
  end

  test "add a video to the playlist" do
    {:ok, video_service} = Videos.create()
    video_service |> Videos.add(%Video{})
    playlist = video_service |> Videos.get_playlist()
    assert length(playlist) == 1
  end

  test "add two videos to the playlist" do
    {:ok, video_service} = Videos.create()
    video_service |> Videos.add(%Video{})
    video_service |> Videos.add(%Video{})
    playlist = video_service |> Videos.get_playlist()
    assert length(playlist) == 2
  end

  test "current video is nil" do
    {:ok, video_service} = Videos.create()
    current_video = video_service |> Videos.get_current()
    assert current_video == nil
  end

  test "set current video" do
    {:ok, video_service} = Videos.create()
    expected = %Video{}
    video_service |> Videos.set_current(expected)
    current = video_service |> Videos.get_current()
    assert current == expected
  end
end
