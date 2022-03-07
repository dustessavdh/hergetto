defmodule HergettoWeb.RoomsController do
  use HergettoWeb, :controller
  alias Hergetto.Rooms

  def new(conn, _params) do
    {:ok, room_id} = Rooms.create()

    conn
    |> put_flash(:info, "Room created")
    |> redirect(to: "/rooms/#{room_id}")
  end
end
