defmodule HergettoWeb.Plugs.UserAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Hergetto.Users
  alias Hergetto.User
  alias AuthenticationWeb.Router.Helpers, as: Routes

  @doc """
  Authenticates the user by looking into the session.
  """
  def fetch_current_user(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)
    user = user_token && Users.get(user_token, :external_id)
    IO.inspect(user)
    assign(conn, :current_user, user)
  end

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: "/")
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the user to be authenticated.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, 'You must be logged in to access this page.')
      |> redirect(to: "/login")
      |> halt()
    end
  end

  defp ensure_user_token(conn) do
    if user_token = get_session(conn, :user_token) do
      {user_token, conn}
    else
      {nil, conn}
    end
  end
end
