defmodule Hergetto.RoomCommunicationHelperTest do
  use ExUnit.Case
  alias Hergetto.Rooms.RoomCommunicationHelper
  alias Hergetto.Structs.RoomEvent

  test "Recieve events on broadcast" do
    RoomCommunicationHelper.subscribe("non-existing-test-room")
    RoomCommunicationHelper.broadcast("non-existing-test-room", :test, %{})
    assert_receive(%RoomEvent{})
  end
end
