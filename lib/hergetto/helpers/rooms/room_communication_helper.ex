defmodule Hergetto.Rooms.RoomCommunicationHelper do
  alias Phoenix.PubSub
  alias Hergetto.Structs.RoomEvent

  @doc """
  Subscribes to notifications from the specified room.

  ## Examples

      iex>RoomCommunicationHelper.subscribe("f2d97ea1-ddaf-4949-b1bc-63766ca8d52b")
      :ok

  """
  def subscribe(room) do
    PubSub.subscribe(Hergetto.PubSub, room)
  end

  @doc """
  Broadcasts an event with data to the specified room.

  ## Examples

      iex> RoomCommunicationHelper.broadcast("f2d97ea1-ddaf-4949-b1bc-63766ca8d52b", :pause, %{})
      :ok

  """
  def broadcast(room, event, data) do
    PubSub.broadcast(Hergetto.PubSub, room, %RoomEvent{event: event, data: data})
  end
end
