defmodule HergettoWeb.VideoLiveTest do
  use HergettoWeb.ConnCase
  # use Hergetto.DataCase
  use Hergetto.RoomsCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn, room: room} do
    {:ok, video_live, disconnected_html} = live(conn, "/watch/#{room.uuid}")
    assert disconnected_html =~ "Room: #{room.uuid}"
    assert render(video_live) =~ "Room: #{room.uuid}"
  end
end
