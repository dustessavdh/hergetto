defmodule HergettoWeb.RoomsLive do
  use HergettoWeb, :live_view
  alias Hergetto.Rooms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, fetch(socket)}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(HergettoWeb.RoomsLiveView, "rooms_live.html", assigns)
  end

  @impl true
  def handle_info(:update, socket) do
    {:noreply, fetch(socket)}
  end

  @impl true
  def handle_event("create_room", %{"private" => %{"is_private" => private?}}, socket) do
    new_room = %{
      uuid: UUID.uuid4(),
      private: private?
    }

    case Rooms.create_room(new_room) do
      {:ok, room} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Room created!")
          |> push_redirect(to: Routes.video_path(socket, :index, room.uuid))
        }
      {:error, changeset} ->
        IO.inspect(changeset)
        {
          :noreply,
          fetch(socket)
          |> put_flash(:error, "Something went wrong when creating a room! Try again in a few minutes!")
        }
    end
  end

  @impl true
  def terminate(_reason, _socket) do
    :normal
  end

  def fetch(socket) do
    socket
    |> assign(rooms: Rooms.list_public_rooms())
  end

  def get_yt_id(url) do
    %{id: id} = Videx.parse(url)
    id
  end
end
