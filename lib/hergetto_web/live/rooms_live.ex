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
  def handle_event("create", _params, socket) do
    new_room = %{
      uuid: UUID.uuid4(),
      current_video: nil,
      playback_position: 0,
      playback_rate: 1.0,
      playlist: []
    }

    case Rooms.create_room(new_room) do
      {:ok, room} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Room created!")
          |> push_redirect(to: "/watch/#{room.uuid}")
        }
      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, fetch(socket)}
    end
  end

  @impl true
  def terminate(_reason, _socket) do
    :normal
  end

  def fetch(socket) do
    socket
    |> assign(rooms: Rooms.list_rooms())
  end
end
