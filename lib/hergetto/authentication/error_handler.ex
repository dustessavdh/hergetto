defmodule Hergetto.Authentication.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller
  alias Hergetto.Authentication.Guardian

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    case type do
      :already_authenticated ->
        conn
        |> redirect(to: "/")
      :unauthenticated ->
        conn
        |> put_flash(:error, "You must be logged in to access this page.")
        |> redirect(to: "/login")
      :invalid_token ->
        conn
        |> Guardian.Plug.sign_out()
        |> Guardian.Plug.clear_remember_me()
        |> put_flash(:error, "An error occurred while authenticating.")
        |> redirect(to: "/login")
      _ ->
        conn
        |> put_flash(:error, "An error occurred while authenticating.")
        |> redirect(to: "/")
    end
  end
end
