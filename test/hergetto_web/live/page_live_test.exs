defmodule HergettoWeb.PageLiveTest do
  use HergettoWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  describe "PageLive" do
    test "disconnected and connected render", %{conn: conn} do
      {:ok, page_live, disconnected_html} = live(conn, "/")
      assert disconnected_html =~ "Resources"
      assert render(page_live) =~ "Resources"
    end

    test "rendered meta tags", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ ~s|<meta content="Hergetto ⋅ Watch videos together!" name="title"/>|

      assert html =~
               ~s|<meta content="synchronized, together, youtube, videos, video, watch, friends, social, hergetto, funny" name="keywords"/>|
    end
  end
end
