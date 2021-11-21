defmodule Hergetto.Rooms.RoomCommunicationHelper do
  @moduledoc """
  This module provides helper functions for communication.
  """

  alias Hergetto.Structs.RoomEvent

  @doc """
  This function creates a `RoomEvent`.

  Returns `%RoomEvent{}.`

  ## Examples

      iex> RoomCommunicationHelper.create_event("play", nil, "me")
      %Hergetto.Structs.RoomEvent{
        data: nil,
        date: ~U[2021-11-21 16:37:21.864894Z],
        event: "play",
        sender: "me"
      }
  """
  def create_event(event, data, sender) do
    %RoomEvent{event: event, data: data, sender: sender, date: DateTime.utc_now()}
  end
end
