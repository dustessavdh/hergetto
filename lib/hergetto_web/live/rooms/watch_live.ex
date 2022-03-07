defmodule HergettoWeb.WatchLive do
  use HergettoWeb, :live_view
  require Logger

  import HergettoWeb.Presence
  alias Hergetto.Rooms
  alias HergettoWeb.LiveMonitor

  @topic "hergetto:rooms:u9hewjr"

  @impl true
  def mount(%{"room_id" => room_id} = _params, session, %{transport_pid: nil} = socket) do
    # Not connected view
    {
      :ok,
      socket
      |> prepare_assigns(session, "Watch")
      |> room_exists?(room_id)
    }
  end

  @impl true
  def mount(%{"room_id" => room_id} = _params, session, socket) do
    # Connected view
    {
      :ok,
      socket
      |> prepare_assigns(session, "Watch")
      |> join_room(room_id)
    }
  end

  def unmount(%{id: id}, _reason) do
    IO.puts("view #{id} unmounted")
    :ok
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{event: "presence_diff", topic: @topic, payload: diff},
        socket
      ) do
    handle_user_presence_diff(socket, diff)
  end

  defp room_exists?(socket, room_id) do
    case Rooms.exists?(room_id) do
      true ->
        socket

      _ ->
        socket
        |> put_flash(:error, "Room not found")
        |> push_redirect(to: "/rooms")
    end
  end

  defp join_room(socket, room_id) do
    case Rooms.join(room_id) do
      {:ok, session_id} ->
        socket
        |> assign(:user_session_id, session_id)
        |> start_user_presence(@topic, self(), %{"user_session_id" => session_id})
        |> LiveMonitor.monitor(self(), __MODULE__, %{user_session_id: session_id})

      {:error, _reason} ->
        socket
        |> put_flash(:error, "Room not found")
        |> push_redirect(to: "/rooms")
    end
  end
end
