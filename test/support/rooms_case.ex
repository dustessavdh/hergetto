defmodule Hergetto.RoomsCase do
  use ExUnit.CaseTemplate

  setup_all tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Hergetto.Repo)
    # we are setting :auto here so that the data persists for all tests,
    # normally (with :shared mode) every process runs in a transaction
    # and rolls back when it exits. setup_all runs in a distinct process
    # from each test so the data doesn't exist for each test.
    Ecto.Adapters.SQL.Sandbox.mode(Hergetto.Repo, :auto)
    {:ok, room} = Hergetto.Rooms.create_room(%{uuid: UUID.uuid4(), private: true})

    on_exit(fn ->
      # this callback needs to checkout its own connection since it
      # runs in its own process
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Hergetto.Repo)
      Ecto.Adapters.SQL.Sandbox.mode(Hergetto.Repo, :auto)

      # we also need to re-fetch the %Rooms struct since Ecto otherwise
      # complains it's "stale"
      room = Hergetto.Rooms.get_room!(room.id)
      Hergetto.Rooms.delete_room(room)
      :ok
    end)

    [room: room]
  end
end
