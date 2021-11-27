defmodule HergettoWeb.AuthController do
  use HergettoWeb, :controller
  plug Ueberauth

  def callback(conn, _params) do
    IO.inspect(conn.assigns)
    conn |> text("test")
  end
end
