defmodule HergettoWeb.AccountLiveTest do
  use HergettoWeb.ConnCase, async: true
  import Hergetto.AccountsFixtures
  import Phoenix.LiveViewTest
  import Hergetto.Authentication.Guardian

  describe "AccountLive" do
    test "Page doesn't load without authentication", %{conn: conn} do
      assert {:error,
              {:redirect,
               %{to: "/login", flash: %{"error" => "You must be logged in to access this page."}}}} =
               live(conn, "/account")
    end
  end
end
