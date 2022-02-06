defmodule HergettoWeb.AuthController do
  use HergettoWeb, :controller
  plug Ueberauth
  alias Hergetto.Users
  alias Hergetto.User

  def signout(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:error, "signed out")
    |> redirect(to: "/")
  end

  def callback(conn, _params) do
    %{
      ueberauth_auth: %Ueberauth.Auth{
        uid: uid,
        info: %Ueberauth.Auth.Info{email: email, image: image}
      }
    } = conn.assigns

    case Users.get(uid, :external_id) do
      %User{} = user ->
        conn
        |> put_session(:user, user)
        |> redirect(to: "/")

      nil ->
        {:ok, user} = Users.create_user(email, image, uid)

        conn
        |> put_session(:user, user)
        |> redirect(to: "/")
    end
  end
end
