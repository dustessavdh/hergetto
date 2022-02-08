defmodule HergettoWeb.LoginLiveTest do
  use HergettoWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "PageLive" do
    test "disconnected and connected render", %{conn: conn} do
      {:ok, login_live, disconnected_html} = live(conn, "/login")
      assert disconnected_html =~ "Login"
      assert render(login_live) =~ "Login"
    end

    test "rendered meta tags", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/login")
      assert html =~ ~s|<meta content="Login ⋅ Watch videos together!" name="title"/>|
    end
  end
end
