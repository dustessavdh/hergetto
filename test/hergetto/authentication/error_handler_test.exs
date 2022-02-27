defmodule Hergetto.ErrorHandlerTest do
  use HergettoWeb.ConnCase, async: true

  alias Hergetto.Authentication.ErrorHandler
  alias Hergetto.Authentication.Guardian.Plug

  describe "Guardian ErrorHandler" do
    test "auth_error/3 with already_authenticated error", %{conn: conn} do
      conn = ErrorHandler.auth_error(conn, {:already_authenticated, "testing"}, "")
      assert html_response(conn, 302) =~ "You are being <a href=\"/\">redirected</a>."
    end

    test "auth_error/3 with unauthenticated error", %{conn: conn} do
      # You must be logged in to access the account page, so this will throw an unauthenticated error
      conn = get(conn, "/account")
      assert html_response(conn, 302) =~ "You are being <a href=\"/login\">redirected</a>."
    end
  end
end
