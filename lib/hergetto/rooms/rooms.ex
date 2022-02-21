defmodule Hergetto.Rooms do
  @moduledoc false
  alias Hergetto.Rooms.RoomSupervisor
  alias Hergetto.Rooms.RoomService
  alias Hergetto.Structs.RoomEvent
  alias Hergetto.Helpers.ServiceStartHelper
  alias Hergetto.Videos
  alias Hergetto.Chats
  alias Phoenix.PubSub

  @doc """
  This function creates a new room.

  Returns `{:ok, uuid}`. This `uuid` represents a room.

  ## Examples

      iex> Rooms.create()
      {:ok, "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"}

  """
  def create do
    {:ok, room} = return = ServiceStartHelper.start(RoomSupervisor, RoomService, nil)
    add_video_service(room)
    add_chat_service(room)
    return
  end

  @doc """
  This function joins a room.

  Returns `{:ok, uuid}`. This `uuid` represents a session.

  ## Examples

      iex> {:ok, room} = Rooms.create()
      {:ok, "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"}
      iex> room |> Rooms.join()
      {:ok, "f3f8e8ef9-fea8-42da-a37d-f5f2074077e"}

  """
  def join(room) do
    with session <- UUID.uuid4(),
         true <- exists?(room),
         pid <- Process.whereis(generate_room_id(room)) do
      GenServer.cast(pid, {:join, session})
      PubSub.subscribe(Hergetto.PubSub, room)
      {:ok, session}
    else
      _ ->
        {:error, :noroom}
    end
  end

  @doc """
  This function leaves a room.

  Returns `:ok`

  ## Examples

      iex> {:ok, room} = Rooms.create()
      {:ok, "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"}
      iex> {:ok, session} = room |> Rooms.join()
      {:ok, "f3f8e8ef9-fea8-42da-a37d-f5f2074077e"}
      iex> session |> Rooms.leave(room)
      :ok

  """
  def leave(session, room) do
    with true <- exists?(room), pid <- Process.whereis(generate_room_id(room)) do
      GenServer.cast(pid, {:leave, session})
      :ok
    else
      _ ->
        :noroom
    end
  end

  @doc """
  Gets the state for the specified `room`.

  Returns `%{participants: [], room_id: ""}`.

  ## Examples

      iex> {:ok, room} = Rooms.create()
      "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"
      iex> room |> Rooms.join()
      "3f8e8ef9-fea8-42da-a37d-f5f2074077ef"
      iex> room |> Rooms.get(:all)
      %{
        participants: ["3f8e8ef9-fea8-42da-a37d-f5f2074077ef"],
        room_id: "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b",
        video_service: nil
      }

  """
  def get(room, type) do
    with true <- exists?(room), pid <- Process.whereis(generate_room_id(room)) do
      GenServer.call(pid, {:get, type})
    else
      _ ->
        {:error, :noroom}
    end
  end

  @doc false
  def get_all(room) do
    get(room, :all)
  end

  @doc false
  def get_participants(room) do
    get(room, :participants)
  end

  @doc false
  def get_video_service(room) do
    get(room, :video_service)
  end

  @doc false
  def get_chat_service(room) do
    get(room, :chat_service)
  end

  @doc """
  Check if the specified `room` exists?.

  Returns `true` or `false`.

  ## Examples

      iex> Rooms.exists?("93a628cc-cec1-4733-b513-aff5824b02da")
      true

  """
  def exists?(room) do
    state = Process.whereis(generate_room_id(room))
    is_pid(state)
  end

  @doc """
  Triggers an event for the specified `room`.

  Returns `:ok` or `:noroom`.

  ## Examples

      iex> {:ok, room} = Rooms.create()
      "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"
      iex> room |> Rooms.trigger("play", nil, "93a628cc-cec1-4733-b513-aff5824b02da")
      :ok
  """
  def trigger(room, event, data, sender) do
    with true <- exists?(room) do
      PubSub.broadcast(Hergetto.PubSub, room, create_event(event, data, sender))
      :ok
    else
      _ ->
        :noroom
    end
  end

  @doc false
  defp add_video_service(room) do
    with true <- exists?(room),
         {:ok, video_service} <- Videos.create(room),
         pid <- Process.whereis(generate_room_id(room)) do
      GenServer.cast(pid, {:video_service, video_service})
      :ok
    else
      _ ->
        :noroom
    end
  end

  @doc false
  defp add_chat_service(room) do
    case exists?(room) do
      true ->
        {:ok, chat_service} = Chats.create(room)
        pid = Process.whereis(generate_room_id(room))
        GenServer.cast(pid, {:chat_service, chat_service})
        :ok

      false ->
        :noroom
    end
  end

  @doc false
  defp generate_room_id(room) do
    :"roomservice:#{room}"
  end

  @doc false
  defp create_event(event, data, sender) do
    %RoomEvent{event: event, data: data, sender: sender, date: DateTime.utc_now()}
  end
end
