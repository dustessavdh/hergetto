defmodule HergettoWeb.Plugs.Authentication do
  @moduledoc """
  This module checks if you are logged in.
  """

  import Phoenix.Controller, only: [redirect: 2]
  import Plug.Conn, only: [halt: 1]
  import Plug.Conn

  @doc false
  def init(default), do: default

  @doc """
  Checks if the user key exists in the session, if not: redirect
  """
  def call(conn, _default) do
    session = get_session(conn)

    if(not Map.has_key?(session, "user")) do
      conn
      |> redirect(to: "/login")
      |> halt()
    else
      conn
    end
  end
end
