defmodule HergettoWeb.VideoLiveTest do
  # use HergettoWeb.ConnCase
  use Hergetto.DataCase

  # import Phoenix.LiveViewTest
  alias Hergetto.Rooms
  alias Hergetto.Rooms.Room


  #FIXME https://elixirforum.com/t/using-setup-all-with-database/8865/5
  setup_all do
    new_room = %{
      uuid: UUID.uuid4(),
      private: true
    }

    case Rooms.create_room(new_room) do
      {:ok, room} ->
        {:ok, room: room}
      {:error, changeset} ->
        IO.inspect(changeset)
        {:error, changeset: changeset}
    end
  end

  # test "disconnected and connected render", %{conn: conn} do
  #   {:ok, video_live, disconnected_html} = live(conn, "/watch/#{:room.uuid}")
  #   assert disconnected_html =~ "Create a room or join one"
  #   assert render(video_live) =~ "Create a room or join one"
  # end

  # assert {:error, changeset} = Accounts.create_user(%{password: "short"})
  # assert "password is too short" in errors_on(changeset).password
  # assert %{password: ["password is too short"]} = errors_on(changeset)

  test "creating a room" do
    assert {:error, changeset} = Rooms.create_room(%{})
  end
end
