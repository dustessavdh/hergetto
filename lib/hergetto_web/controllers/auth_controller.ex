defmodule HergettoWeb.AuthController do
  use HergettoWeb, :controller
  plug Ueberauth
  alias Hergetto.Accounts
  alias Hergetto.Accounts.User
  alias Hergetto.Accounts.UserHelper, as: UH
  alias Hergetto.Authentication.Guardian

  def callback(%{assigns: %{ueberauth_auth: auth_info}} = conn, _params) do
    user_params = %{
      profile_picture: Routes.static_path(conn, "/assets/avatars/default.svg"),
      external_id: auth_info.uid,
      provider: Atom.to_string(auth_info.provider),
      email: auth_info.info.email
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

  defp login(conn, user, redirect_url \\ "/") do
    conn
    |> put_flash(:info, "Signed in as #{user.username}")
    |> Guardian.Plug.sign_in(user)
    |> Guardian.Plug.remember_me(user)
    |> redirect(to: redirect_url)
  end

  defp register(conn, user_params) do
    case create_user(user_params) do
      {:ok, user} ->
        login(conn, user, "/account")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error registering!")
        |> redirect(to: "/login")
    end
  end

  defp create_user(user_params) do
    username = UH.generate_username()

    user_params =
      user_params
      |> Map.put_new(:username, username)
      |> Map.put_new(:tag, UH.generate_tag())
      |> Map.put_new(:profile_colour, UH.get_color_for_username(username))

    Accounts.create_user(user_params)
  end
end
