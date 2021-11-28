defmodule HergettoWeb.PageLiveTest do
  use HergettoWeb.ConnCase

  import Phoenix.LiveViewTest

  test "rendered meta tags", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")
    assert html =~ ~s|<meta content="Hergetto · Together in a safe way!" name="title"/>|
    assert html =~ ~s|<meta content="phoenix watch youtube videos together hergetto" name="keywords"/>|
  end
end
