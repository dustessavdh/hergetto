defmodule Hergetto.Structs.RoomEvent do
  @moduledoc """
  This module represents an event that gets broadcast by the RoomService.
  """

  defstruct [:event, :data, :sender, :date]
end
