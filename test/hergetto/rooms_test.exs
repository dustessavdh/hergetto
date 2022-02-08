defmodule Hergetto.RoomsTest do
  use ExUnit.Case
  alias Hergetto.Rooms
  alias Hergetto.Structs.RoomEvent

  describe "Room service" do
    test "creates a room" do
      {:ok, room} = Rooms.create()
      assert room != nil
    end

    test "creates a session and joins a room" do
      {:ok, room} = Rooms.create()
      {:ok, session} = room |> Rooms.join()
      assert session != nil
    end

    test "get state for room" do
      {:ok, room} = Rooms.create()
      assert room |> Rooms.get_all() != nil
    end

    test "get participants for room with one participant" do
      {:ok, room} = Rooms.create()
      {:ok, _session} = room |> Rooms.join()
      %{participants: participants} = room |> Rooms.get_all()
      assert length(participants) == 1
    end

    test "get participants for room with two participants" do
      {:ok, room} = Rooms.create()
      {:ok, _session} = room |> Rooms.join()
      {:ok, _session} = room |> Rooms.join()
      %{participants: participants} = room |> Rooms.get_all()
      assert length(participants) == 2
    end

    test "leave a room" do
      {:ok, room} = Rooms.create()
      {:ok, session} = room |> Rooms.join()
      session |> Rooms.leave(room)
      %{participants: participants} = room |> Rooms.get_all()
      assert Enum.empty?(participants)
    end

    test "Recieve events on broadcast" do
      {:ok, room} = Rooms.create()
      room |> Rooms.join()
      room |> Rooms.trigger("", "", "")
      assert_receive(%RoomEvent{})
    end
  end
end
