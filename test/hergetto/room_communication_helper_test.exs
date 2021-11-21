defmodule Hergetto.RoomCommunicationHelperTest do
  use ExUnit.Case
  alias Hergetto.Rooms.RoomCommunicationHelper

  test "Creates a RoomEvent structs" do
    event = RoomCommunicationHelper.create_event("test_event", "", "")
    assert(event.event == "test_event")
  end
end
