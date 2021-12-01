defmodule HergettoWeb.PageLiveTest do
  use HergettoWeb.ConnCase
  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Resources"
    assert render(page_live) =~ "Resources"
  end

  test "rendered meta tags", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")
    assert html =~ ~s|<meta content="Hergetto · Together in a safe way!" name="title"/>|
    assert html =~ ~s|<meta content="phoenix watch youtube videos together hergetto" name="keywords"/>|
  end
end
