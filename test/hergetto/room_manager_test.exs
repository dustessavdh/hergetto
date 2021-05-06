defmodule Hergetto.RoomManagerTest do
  use ExUnit.Case
  alias Hergetto.Rooms.RoomManager

  test "creates a room" do
    assert RoomManager.create() != nil
  end

  test "creates a session and joins a room" do
    room = RoomManager.create()
    assert RoomManager.join(room)
  end

  test "get state for room" do
    room = RoomManager.create()
    RoomManager.join(room)
    assert RoomManager.get(room) != nil
  end

  test "get participants for room with one participant" do
    room = RoomManager.create()
    RoomManager.join(room)
    participants = RoomManager.get(room, :participants)
    assert participants.length == 1
  end

  test "get participants for room with two participants" do
    room = RoomManager.create()
    RoomManager.join(room)
    RoomManager.join(room)
    participants = RoomManager.get(room, :participants)
    assert participants.length == 2
  end

  test "leave a room" do
    room = RoomManager.create()
    session = RoomManager.join(room)
    RoomManager.leave(session, room)
    participants = RoomManager.get(room, :participants)
    assert participants.length == 0
  end
end
