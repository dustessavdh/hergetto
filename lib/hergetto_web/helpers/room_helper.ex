defmodule HergettoWeb.RoomHelper do
  @moduledoc """
  The roomHelper is used for common functionality for a room.
  It has all the PubSub methods and other useful methods.
  """

  alias Hergetto.Rooms
  alias Hergetto.Rooms.Room
  @topic inspect(__MODULE__)

  @doc """
  Subscribes to the topic with Pubsub.
  """
  def subscribe do
    Phoenix.PubSub.subscribe(Hergetto.PubSub, @topic)
  end

  @doc """
  Subscribes to a specific topic with Pubsub.

  ## Parameters

    - id: String that represents uuid of the room to subscribe to.

  """
  def subscribe(id) do
    Phoenix.PubSub.subscribe(Hergetto.PubSub, "#{@topic}:#{id}")
  end

  @doc """
  Subscribes to a specific participant in the room with Pubsub.

  ## Parameters

    - id: String that represents uuid of the room to subscribe to.
    - participant: String that represents the uuid of the participant in a room to subscribe to.

  """
  def subscribe(id, participant) do
    Phoenix.PubSub.subscribe(Hergetto.PubSub, "#{@topic}:#{id}:#{participant}")
  end

  @doc """
  Broadcast to the topic with Pubsub.

  ## Parameters

  - message: message to broadcast to the topic.

  """
  def broadcast(message) do
    Phoenix.PubSub.broadcast(Hergetto.PubSub, @topic, message)
  end

  @doc """
  Broadcast to a specific topic with Pubsub.

  ## Parameters

  - id: String that represents uuid of the room to subscribe to.
  - message: message to broadcast to the topic.

  """
  def broadcast(id, message) do
    Phoenix.PubSub.broadcast(Hergetto.PubSub, "#{@topic}:#{id}", message)
  end

  @doc """
  Broadcast to a specific topic with Pubsub.

  ## Parameters

  - id: String that represents uuid of the room to subscribe to.
  - broadcast_id: uuid of the person broadcasting the event.
  - event_type: String that represents the type of event that has happened.

  """
  def broadcast(id, broadcast_id, event_type) do
    Phoenix.PubSub.broadcast(Hergetto.PubSub, "#{@topic}:#{id}", %{
      event_type: event_type,
      broadcast_id: broadcast_id
    })
  end

  @doc """
  Broadcast to a specific participant in the room with Pubsub.

  ## Parameters

  - id: String that represents uuid of the room to subscribe to.
  - broadcast_id: uuid of the person broadcasting the event.
  - participant: String that represents the uuid of the participant in a room to broadcast to.
  - event_type: String that represents the type of event that has happened.

  """
  def broadcast_to_participant(id, broadcast_id, participant, event_type) do
    Phoenix.PubSub.broadcast(Hergetto.PubSub, "#{@topic}:#{id}:#{participant}", %{
      event_type: event_type,
      broadcast_id: broadcast_id
    })
  end

  @doc """
  Add a participant to a room in the database

  ## Parameters

  - room: Changeset of the room to add a participant to.
  - participant: Uuid that represents the participant.

  """
  def set_participant(%Room{} = room, participant) do
    room_changes =
      cond do
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

  @doc """
  Remove a participant from a room in the database

  ## Parameters

  - room: Changeset of the room to remove a participant to.
  - participant: Uuid that represents the participant.

  """
  def remove_participant(%Room{} = room, participant) do
    room_changes =
      cond do
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
