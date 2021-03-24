defmodule Hergetto.DatabaseSchedulerTest do
  use Hergetto.DataCase

  alias Hergetto.Rooms

  def testing do
    ~N[2021-03-04 00:50:12.277000]
  end

  describe "database scheduler" do
    alias Hergetto.Rooms.Room
    alias Hergetto.DatabaseScheduling

    @stale_attrs %{
      current_video: "Old stale video",
      loop: true,
      paused: true,
      playback_position: 42,
      playback_rate: 120.5,
      playlist: [],
      played_playlist: [],
      uuid: UUID.uuid4(),
      owner: UUID.uuid4(),
      participants: [UUID.uuid4()],
      private: true,
      updated_at: DatabaseScheduling.get_x_ago_datetime(87000)
    }

    @not_stale_attrs %{
      current_video: "Old stale video",
      loop: true,
      paused: true,
      playback_position: 42,
      playback_rate: 120.5,
      playlist: [],
      played_playlist: [],
      uuid: UUID.uuid4(),
      owner: UUID.uuid4(),
      participants: [UUID.uuid4()],
      private: true,
    }

    @empty_attrs %{
      current_video: "Old stale video",
      loop: true,
      paused: true,
      playback_position: 42,
      playback_rate: 120.5,
      playlist: [],
      played_playlist: [],
      uuid: UUID.uuid4(),
      owner: UUID.uuid4(),
      participants: [],
      private: true,
      updated_at: DatabaseScheduling.get_x_ago_datetime(1900)
    }

    @not_empty_attrs %{
      current_video: "Old stale video",
      loop: true,
      paused: true,
      playback_position: 42,
      playback_rate: 120.5,
      playlist: [],
      played_playlist: [],
      uuid: UUID.uuid4(),
      owner: UUID.uuid4(),
      participants: [UUID.uuid4(), UUID.uuid4()],
      private: true,
      updated_at: DatabaseScheduling.get_x_ago_datetime(1900)
    }

    test "clean_stale_rooms/0 removes all stale rooms" do
      assert {:ok, %Room{:uuid => r_uuid, :updated_at => r_updated_at}} = Rooms.create_room(@stale_attrs)
      deleted_rooms = {1, [{r_uuid, r_updated_at}]}
      assert deleted_rooms == DatabaseScheduling.clean_stale_rooms()
    end

    test "clean_stale_rooms/0 with no stale rooms does not remove any rooms" do
      assert {:ok, %Room{}} = Rooms.create_room(@not_stale_attrs)
      assert {0, []} == DatabaseScheduling.clean_stale_rooms()
    end

    test "clean_empty_rooms/0 removes all empty rooms" do
      assert {:ok, %Room{:uuid => r_uuid, :updated_at => r_updated_at}} = Rooms.create_room(@empty_attrs)
      deleted_rooms = {1, [{r_uuid, r_updated_at}]}
      assert deleted_rooms == DatabaseScheduling.clean_empty_rooms()
    end

    test "clean_empty_rooms/0 with no empty rooms does not remove any rooms" do
      assert {:ok, %Room{} = room} = Rooms.create_room(@not_empty_attrs)
      assert {0, []} == DatabaseScheduling.clean_empty_rooms()
    end
  end
end
