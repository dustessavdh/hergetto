defmodule HergettoWeb.AuthController do
  use HergettoWeb, :controller
  plug Ueberauth
  alias Hergetto.Users
  alias Hergetto.Authentication.Guardian

  def callback(%{assigns: %{ueberauth_auth: auth_info}} = conn, _params) do
    user_params = %{
      email: auth_info.info.email,
      token: auth_info.credentials.token,
      profile_picture: auth_info.info.image,
      external_id: auth_info.uid,
      provider: Atom.to_string(auth_info.provider)
    }

    signin(conn, user_params)
  end

  def signout(conn, _params) do
    conn
    |> put_flash(:info, "Signed out")
    |> Guardian.Plug.sign_out()
    |> Guardian.Plug.clear_remember_me()
    |> redirect(to: "/")
  end

  defp signin(conn, user_params) do
    case insert_or_update_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Signed in as #{user.email}")
        |> Guardian.Plug.sign_in(user)
        |> Guardian.Plug.remember_me(user)
        |> redirect(to: "/")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in!")
        |> redirect(to: "/login")
    end
  end

  defp insert_or_update_user(user_params) do
    case Users.get(user_params.external_id, :external_id) do
      nil ->
        Users.create_user(
          user_params.email,
          user_params.token,
          user_params.profile_picture,
          user_params.external_id,
          user_params.provider
        )

      user ->
        {:ok, user}
    end
  end
end
