defmodule Hergetto.DatabaseScheduling do
  @moduledoc """
  Contains all the scheduling functions rela the database
  """

  alias Hergetto.Rooms.Room
  alias Hergetto.Rooms

  import Ecto.Query, warn: false
  require Logger

  @doc """
  Removes all roons that haven't been update for more than a day.
  Looks at the current time then subtracts a day to get yesterday and all rooms older than that will be removed.
  """
  def clean_stale_rooms do
    Logger.notice("Cleaning stale rooms older than a day!")

    query = from r in Room,
            where: r.updated_at <= ^get_x_ago_datetime(86000),
            select: {r.uuid, r.updated_at}

    deleted_rooms = Rooms.delete_rooms_with_query(query)
    Logger.debug("Deleted stale rooms (amount, rooms): #{inspect deleted_rooms}")
    deleted_rooms
  end

  @doc """
  Removes all rooms that haven't been updated for more than half an hour and have no participants in them.
  Looks at the current time then subtracts half an hout to get the correct time and all empty rooms older than that will be removed.
  """
  def clean_empty_rooms do
    Logger.notice("Cleaning empty rooms!")
    query = from r in Room,
            where: r.updated_at <= ^get_x_ago_datetime(1800) and fragment("? = '{}'", r.participants),
            select: {r.uuid, r.updated_at}

    deleted_rooms = Rooms.delete_rooms_with_query(query)
    Logger.debug("Deleted empty rooms (amount, rooms): #{inspect deleted_rooms}")
    deleted_rooms
  end

  defp get_x_ago_datetime(seconds) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(-seconds, :second)
  end
end
