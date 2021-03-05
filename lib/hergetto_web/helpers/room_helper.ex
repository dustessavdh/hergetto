defmodule HergettoWeb.RoomHelper do
  alias Hergetto.Rooms
  alias Hergetto.Rooms.Room
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Hergetto.PubSub, @topic)
  end

  def subscribe(id) do
    Phoenix.PubSub.subscribe(Hergetto.PubSub, "#{@topic}:#{id}")
  end

  def subscribe(id, participant) do
    Phoenix.PubSub.subscribe(Hergetto.PubSub, "#{@topic}:#{id}:#{participant}")
  end

  def broadcast(message) do
    Phoenix.PubSub.broadcast(Hergetto.PubSub, @topic, message)
  end

  def broadcast(id, message) do
    Phoenix.PubSub.broadcast(Hergetto.PubSub, "#{@topic}:#{id}", message)
  end

  def broadcast(id, broadcast_id, event_type) do
    Phoenix.PubSub.broadcast(Hergetto.PubSub, "#{@topic}:#{id}", %{event_type: event_type, broadcast_id: broadcast_id})
  end

  def broadcast_to_participant(id, broadcast_id, participant, event_type) do
    Phoenix.PubSub.broadcast(Hergetto.PubSub, "#{@topic}:#{id}:#{participant}", %{event_type: event_type, broadcast_id: broadcast_id})
  end

  def set_participant(%Room{} = room, participant) do
    room_changes = cond do
      room.owner == nil ->
        %{owner: participant, participants: room.participants ++ [participant]}
      true ->
        %{participants: room.participants ++ [participant]}
    end
    case Rooms.update_room(room, room_changes) do
      {:ok, room} ->
        room
      {:error, _changeset} ->
        room
    end
  end

  def remove_participant(%Room{} = room, participant) do
    # TODO Fix
    room_changes = cond do
      room.owner == participant ->
        %{owner: nil, participants: room.participants -- [participant]}
      true ->
        %{participants: room.participants -- [participant]}
    end
    case Rooms.update_room(room, room_changes) do
      {:ok, room} ->
        room
      {:error, _changeset} ->
        room
    end
  end
end
