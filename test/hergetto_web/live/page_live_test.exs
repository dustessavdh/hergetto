defmodule HergettoWeb.PageLiveTest do
  use HergettoWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Hergetto!"
    assert render(page_live) =~ "Welcome to Hergetto!"
  end
end
