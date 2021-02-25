defmodule HergettoWeb.VideoLive do
  use HergettoWeb, :live_view
  alias Hergetto.Rooms
  alias Hergetto.Rooms.Room
  alias Hergetto.Rooms.Video
  alias HergettoWeb.RoomHelper
  alias HergettoWeb.VideoHelper

  # TODO:
  # volgende video afspelen wanneer de andere klaar is.
  # playlist maken waar alle verwijderde playlist items naar toe gaan
  # skip knop maken
  # vorige knop maken

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    RoomHelper.subscribe(id)
    {:ok, fetch(socket, :setup, id)}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(HergettoWeb.VideoLiveView, "video_live.html", assigns)
  end

  @impl true
  def terminate(_reason, _socket) do
    :normal
  end

  @impl true
  def handle_info(%{event_type: event_type, broadcast_id: broadcast_id}, socket) do
    IO.puts("handle_info manager")
    case broadcast_id do
      id when id == socket.assigns.broadcast_id ->
        {:noreply, fetch(socket, :room_changed)}
      _id ->
        handle_info(event_type, socket)
    end
  end

  @impl true
  def handle_info("changed_cur_vid", socket) do
    IO.puts("current video changed")
    {:noreply, fetch(socket, :change_video)}
  end

  @impl true
  def handle_info("changed_playlist", socket) do
    IO.puts("playlist changed")
    {:noreply, fetch(socket, :room_changed)}
  end

  @impl true
  def handle_info("play_video", socket) do
    IO.puts("Video is playing")
    {:noreply, fetch(socket, :play_video)}
  end

  @impl true
  def handle_info("pause_video", socket) do
    IO.puts("Video is paused")
    {:noreply, fetch(socket, :pause_video)}
  end

  @impl true
  def handle_info("changed_playback_rate", socket) do
    IO.puts("playback_rate changed")
    {:noreply, fetch(socket, :playback_rate_changed)}
  end

  @impl true
  def handle_event("change_cur_vid", %{"value" => vid_index}, socket) do
    room_changes =
      vid_index
      |> VideoHelper.set_current_video(socket.assigns.room.playlist, %{})
      |> VideoHelper.delete_video(socket.assigns.room.playlist, vid_index)

    case Rooms.update_room(socket.assigns.room, room_changes) do
      {:ok, _room} ->
        RoomHelper.broadcast(socket.assigns.room.uuid, socket.assigns.broadcast_id, "changed_cur_vid")
        {:noreply, fetch(socket, :change_video)}
      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("validate_video", %{"video" => video}, socket) do
    IO.inspect(video)
    changeset =
    %Video{}
    |> Video.changeset(video)
    |> Map.put(:action, :insert)

    case Videx.parse(Map.get(video, "add_video", "")) do
      nil ->
        {:noreply, fetch(
          socket,
          :validate_video,
          changeset
          |> Ecto.Changeset.add_error(:add_video, "isn't a valid url", validation: :format)
          )}
      _parsed ->
        {:noreply, fetch(socket, :validate_video, changeset)}
    end


  end

  @impl true
  def handle_event("add_vid", %{"video" => %{"add_video" => video}}, socket) do
    room_changes =
      socket.assigns.room.playlist
      |> VideoHelper.add_video(video, %{})

    case Rooms.update_room(socket.assigns.room, room_changes) do
      {:ok, _room} ->
        RoomHelper.broadcast(socket.assigns.room.uuid, socket.assigns.broadcast_id, "changed_playlist")
        {:noreply, fetch(socket, :room_changed)}

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("remove_vid", %{"value" => vid_index}, socket) do
    room_changes =
      %{}
      |> VideoHelper.delete_video(socket.assigns.room.playlist, vid_index)

    case Rooms.update_room(socket.assigns.room, room_changes) do
      {:ok, _room} ->
        RoomHelper.broadcast(socket.assigns.room.uuid, socket.assigns.broadcast_id, "changed_playlist")
        {:noreply, fetch(socket, :room_changed)}

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("play_video", %{"playback_position" => playback_position}, socket) do
    room_changes = VideoHelper.change_video_state(false, playback_position)
    case Rooms.update_room(socket.assigns.room, room_changes) do
      {:ok, _room} ->
        RoomHelper.broadcast(socket.assigns.room.uuid, socket.assigns.broadcast_id, "play_video")
        {:noreply, fetch(socket, :room_changed)}

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("pause_video", _params, socket) do
    room_changes = VideoHelper.change_video_state(true)
    case Rooms.update_room(socket.assigns.room, room_changes) do
      {:ok, _room} ->
        RoomHelper.broadcast(socket.assigns.room.uuid, socket.assigns.broadcast_id, "pause_video")
        {:noreply, fetch(socket, :room_changed)}

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("playback_rate_changed", %{"playback_rate" => playback_rate}, socket) do
    room_changes = VideoHelper.change_playback_rate(playback_rate)
    case Rooms.update_room(socket.assigns.room, room_changes) do
      {:ok, _room} ->
        RoomHelper.broadcast(socket.assigns.room.uuid, socket.assigns.broadcast_id, "changed_playback_rate")
        {:noreply, fetch(socket, :room_changed)}

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, socket}
    end
  end

  def fetch(socket, :room, id) do
    case Rooms.get_room(id, :uuid) do
      %Room{} = room ->
        {
          :ok,
          socket
          |> assign(room: room)
          |> assign(changeset: Video.changeset(%Video{}, %{}))
        }
      nil ->
        {
          :error,
          socket
          |> put_flash(:error, "That room doesn't exist")
          |> push_redirect(to: "/watch")
        }
    end
  end

  def fetch(socket, :setup, id) do
    case fetch(socket, :room, id) do
      {:ok, socket} ->
        video = Map.get(socket.assigns.room, :current_video)
        load_id = case Videx.parse(video) do
          %{id: id} ->
            raw_time = Map.get(socket.assigns.room, :playback_position) / 10
            {time, _} = Integer.parse("#{raw_time}")
            "#{id}?t=#{time}s"
          _ ->
            "M7lc1UVf-VE"
        end
        broadcast_id = UUID.uuid4()
        socket
        |> assign(broadcast_id: broadcast_id)
        |> assign(room: RoomHelper.set_participant(socket.assigns.room, broadcast_id))
        |> assign(load_id: load_id)
      {:error, socket} ->
        socket
    end
  end

  def fetch(socket, :validate_video, changeset) do
    socket
    |> assign(changeset: changeset)
  end

  def fetch(socket, :room_changed) do
    case fetch(socket, :room, socket.assigns.room.uuid) do
      {:ok, socket} ->
        socket
      {:error, socket} ->
        socket
    end
  end

  def fetch(socket, :play_video) do
    case fetch(socket, :room, socket.assigns.room.uuid) do
      {:ok, socket} ->
        socket
        |> push_event("play_video", %{paused: false, playback_position: socket.assigns.room.playback_position})
      {:error, socket} ->
        socket
    end
  end

  def fetch(socket, :pause_video) do
    case fetch(socket, :room, socket.assigns.room.uuid) do
      {:ok, socket} ->
        socket
        |> push_event("pause_video", %{paused: true})
      {:error, socket} ->
        socket
    end
  end

  def fetch(socket, :change_video) do
    case fetch(socket, :room, socket.assigns.room.uuid) do
      {:ok, socket} ->
        case Videx.parse(socket.assigns.room.current_video) do
          %{id: id, params: %{"t" => time}} ->
            start_time = case Integer.parse(String.replace(time, ~r/\D+/, "")) do
              {parsed_time, _} ->
                parsed_time
              :error ->
                0
            end
            socket
            |> push_event("change_vid", %{cur_vid: id, start_time: start_time})
          %{id: id} ->
            socket
            |> push_event("change_vid", %{cur_vid: id, start_time: 0})
          _ ->
            socket
            |> put_flash(:error, "That wasn't a valid url!")
        end
      {:error, socket} ->
        socket
    end
  end

  def fetch(socket, :playback_rate_changed) do
    case fetch(socket, :room, socket.assigns.room.uuid) do
      {:ok, socket} ->
        socket
        |> push_event("change_playback_rate", %{playback_rate: socket.assigns.room.playback_rate})
      {:error, socket} ->
        socket
    end
  end
end
