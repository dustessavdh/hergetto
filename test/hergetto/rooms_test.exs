defmodule Hergetto.RoomsTest do
  use Hergetto.DataCase

  alias Hergetto.Rooms

  describe "rooms" do
    alias Hergetto.Rooms.Room

    @valid_attrs %{
      current_video: "some current_video",
      loop: true,
      paused: true,
      playback_position: 42,
      playback_rate: 120.5,
      playlist: [],
      played_playlist: [],
      uuid: UUID.uuid4(),
      owner: UUID.uuid4(),
      participants: [],
      private: true
    }
    @update_attrs %{
      current_video: "some updated current_video",
      loop: false,
      paused: false,
      playback_position: 43,
      playback_rate: 456.7,
      playlist: [],
      played_playlist: [],
      uuid: UUID.uuid4(),
      owner: UUID.uuid4(),
      participants: [],
      private: false
    }
    @invalid_attrs %{
      current_video: nil,
      loop: nil,
      paused: nil,
      playback_position: nil,
      playback_rate: nil,
      playlist: nil,
      played_playlist: nil,
      uuid: nil,
      owner: nil,
      participants: nil,
      private: nil
    }

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Rooms.create_room(@valid_attrs)
      assert room.current_video == "some current_video"
      assert room.loop == true
      assert room.paused == true
      assert room.playback_position == 42
      assert room.playback_rate == 120.5
      assert room.playlist == []
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Rooms.update_room(room, @update_attrs)
      assert room.current_video == "some updated current_video"
      assert room.loop == false
      assert room.paused == false
      assert room.playback_position == 43
      assert room.playback_rate == 456.7
      assert room.playlist == []
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end
end
