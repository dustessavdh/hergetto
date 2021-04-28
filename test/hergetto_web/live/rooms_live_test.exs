defmodule HergettoWeb.RoomsLiveTest do
  use HergettoWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, rooms_live, disconnected_html} = live(conn, "/watch")
    assert disconnected_html =~ "Create a room or join one"
    assert render(rooms_live) =~ "Create a room or join one"
  end
end
