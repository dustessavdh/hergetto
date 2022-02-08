defmodule Hergetto.VideosTest do
  use ExUnit.Case
  alias Hergetto.Videos
  alias Hergetto.Structs.Video

  describe "Video service" do
    test "creates a video service" do
      {:ok, video_service} = Videos.create(nil)
      assert video_service != nil
    end

    test "add a video to the playlist" do
      {:ok, video_service} = Videos.create(nil)
      video_service |> Videos.add(%Video{})
      playlist = video_service |> Videos.get_playlist()
      assert length(playlist) == 1
    end

    test "add two videos to the playlist" do
      {:ok, video_service} = Videos.create(nil)
      video_service |> Videos.add(%Video{})
      video_service |> Videos.add(%Video{})
      playlist = video_service |> Videos.get_playlist()
      assert length(playlist) == 2
    end

    test "delete a video from the playlist" do
      {:ok, video_service} = Videos.create(nil)
      video_service |> Videos.add(%Video{})
      video_service |> Videos.add(%Video{})
      video_service |> Videos.delete(0)
      playlist = video_service |> Videos.get_playlist()
      assert length(playlist) == 1
    end

    test "next video" do
      {:ok, video_service} = Videos.create(nil)
      video_service |> Videos.add(%Video{name: "1"})
      video_service |> Videos.add(%Video{name: "2"})
      video_service |> Videos.next()
      %Video{name: name} = video_service |> Videos.get_current()
      assert name == "1"
    end

    test "current video is nil" do
      {:ok, video_service} = Videos.create(nil)
      current_video = video_service |> Videos.get_current()
      assert current_video == nil
    end

    test "set current video" do
      {:ok, video_service} = Videos.create(nil)
      expected = %Video{}
      video_service |> Videos.set_current(expected)
      current = video_service |> Videos.get_current()
      assert current == expected
    end

    test "Get all info about a video service" do
      {:ok, video_service} = Videos.create(nil)

      %{:current => current, :playlist => playlist, :video_service => service_id} =
        Videos.get_all(video_service)

      assert current == nil
      assert Enum.empty?(playlist)
      assert service_id == video_service
    end
  end
end
