defmodule HergettoWeb.VideoLive do
  use HergettoWeb, :live_view
  alias Hergetto.Rooms
  alias Hergetto.Rooms.Room
  alias HergettoWeb.RoomHelper
  alias HergettoWeb.VideoHelper

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    RoomHelper.subscribe(id)
    {
      :ok,
      fetch(socket, :room, id)
      |> assign(broadcast_id: UUID.uuid4())
    }
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(HergettoWeb.VideoLiveView, "video_live.html", assigns)
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
    {:noreply, push_event(fetch(socket, :room_changed), "change_vid", %{curr_vid: socket.assigns.room.current_video})}
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
        {:noreply, fetch(socket, :room_changed)}

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("validate_vid", %{"room" => params}, socket) do
    IO.puts("================================")
    IO.inspect(params)
    changeset =
    %Room{}
    |> Rooms.change_room(params)
    # |> Ecto.Changeset.add_error(:add_video, "isn't a valid url", validation: :format)
    # |> Ecto.Changeset.validate_format(:add_video, ~r/^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$/, message: "isn't a youtube video!")
    |> Map.put(:action, :insert)

    IO.inspect(changeset)
    IO.puts("================================")

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("add_vid", %{"room" => %{"add_video" => video}}, socket) do
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
  def handle_event("playback_rate_changed", playback_rate, socket) do
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

  @impl true
  def terminate(_reason, _socket) do
    :normal
  end

  def fetch(socket, :room, id) do
    case Rooms.get_room(id, :uuid) do
      %Room{} = room ->
        socket
        |> assign(room: room)
        |> assign(changeset: Room.changeset(room, %{add_video: ""}))

      nil ->
        socket
        |> put_flash(:error, "That room doesn't exist")
        |> push_redirect(to: "/watch")
    end
  end

  def fetch(socket, :room_changed) do
    fetch(socket, :room, socket.assigns.room.uuid)
  end

  def fetch(socket, :play_video) do
    case Rooms.get_room(socket.assigns.room.id) do
      %Room{} = room ->
        socket
        |> assign(room: room)
        |> assign(changeset: Room.changeset(room, %{}))
        |> push_event("play_video", %{paused: false, playback_position: room.playback_position})

      nil ->
        socket
        |> put_flash(:error, "That room doesn't exist")
        |> push_redirect(to: "/watch")
    end
  end

  def fetch(socket, :pause_video) do
    fetch(socket, :room_changed)
    |> push_event("pause_video", %{paused: true})
  end

  def fetch(socket, :playback_rate_changed) do
    case Rooms.get_room(socket.assigns.room.id) do
      %Room{} = room ->
        socket
        |> assign(room: room)
        |> assign(changeset: Room.changeset(room, %{}))
        |> push_event("change_playback_rate", %{playback_rate: room.playback_rate})

      nil ->
        socket
        |> put_flash(:error, "That room doesn't exist")
        |> push_redirect(to: "/watch")
    end
  end
end
