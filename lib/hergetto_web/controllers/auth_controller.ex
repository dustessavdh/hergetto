defmodule HergettoWeb.AuthController do
  use HergettoWeb, :controller
  plug Ueberauth
  alias Hergetto.Accounts
  alias Hergetto.Accounts.User
  alias Hergetto.Authentication.Guardian

  def callback(%{assigns: %{ueberauth_auth: auth_info}} = conn, _params) do
    user_params = %{
      profile_picture: auth_info.info.image,
      external_id: auth_info.uid,
      provider: Atom.to_string(auth_info.provider)
    }

    login_or_register(conn, user_params)
  end

  def logout(conn, _params) do
    conn
    |> put_flash(:info, "Signed out")
    |> Guardian.Plug.sign_out()
    |> Guardian.Plug.clear_remember_me()
    |> clear_session()
    |> redirect(to: "/")
  end

  defp login_or_register(conn, user_params) do
    case Accounts.get_user(user_params.external_id, :external_id) do
      %User{} = user ->
        login(conn, user)

      nil ->
        register(conn, user_params)

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in!")
        |> redirect(to: "/login")
    end
  end

  defp login(conn, user) do
    conn
    |> put_flash(:info, "Signed in as #{user.username}")
    |> Guardian.Plug.sign_in(user)
    |> Guardian.Plug.remember_me(user)
    |> redirect(to: "/")
  end

  defp register(conn, user_params) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user_params)
    conn
    |> put_session(:user_to_register, token)
    |> redirect(to: "/register")
  end
end
