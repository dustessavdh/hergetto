defmodule Hergetto.Rooms.RoomManager do
  @moduledoc """
  This module manages and creates rooms.
  """

  use GenServer
  require Logger

  alias Hergetto.Structs.SessionRoom
  alias Hergetto.Rooms.RoomService
  alias Hergetto.Rooms.RoomCommunicationHelper
  alias Phoenix.PubSub

  # Client

  @doc """
  Starts the RoomManager.

  Returns `{:ok, pid}` or `{:error, reason}`.
  """
  def start_link(_) do
    Logger.info("RoomManager starting.")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  This function joins a room.

  Returns `uuid`. This `uuid` represensts a session. This function also subscribes to events from the room via PubSub.

  ## Examples

      iex> room = RoomManager.create()
      "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"
      iex> session = RoomManager.join(room)
      "3f8e8ef9-fea8-42da-a37d-f5f2074077ef"

  """
  def join(room) do
    PubSub.subscribe(Hergetto.PubSub, room)
    session_room = %SessionRoom{session: UUID.uuid4(), room: room}
    GenServer.call(Process.whereis(__MODULE__), {:join, session_room})
  end

  @doc """
  This function leaves a room.

  ## Examples

      iex> room = RoomManager.create()
      "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"
      iex> session = RoomManager.join(room)
      "3f8e8ef9-fea8-42da-a37d-f5f2074077ef"
      iex> RoomManager.leave(session, room)
      :ok

  """
  def leave(session, room) do
    GenServer.cast(Process.whereis(__MODULE__), {:leave, %SessionRoom{session: session, room: room}})
  end

  @doc """
  This function creates a new room.

  Returns `uuid`. This `uuid` represents a room.

  ## Examples

      iex> RoomManager.create()
      "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"

  """
  def create() do
    room = UUID.uuid4()
    GenServer.call(Process.whereis(__MODULE__), {:create, room})
  end

  @doc """
  Gets the state for the specified `room`.

  Returns `%{participants: [], room_id: ""}`.

  ## Examples

      iex> room = RoomManager.create()
      "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"
      iex> RoomManager.join(room)
      "3f8e8ef9-fea8-42da-a37d-f5f2074077ef"
      iex> RoomManager.get(room)
      %{
        participants: ["3f8e8ef9-fea8-42da-a37d-f5f2074077ef"],
        room_id: "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"
      }

  """
  def get(room) do
    GenServer.call(Process.whereis(__MODULE__), {:get, room})
  end

  @doc """
  This function returns more specific information about a room.
  The currently supported atoms are: `:participants`.

  ## Example for `:participants`.

      iex> room = RoomManager.create()
      "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"
      iex> RoomManager.join(room)
      "3f8e8ef9-fea8-42da-a37d-f5f2074077ef"
      iex> RoomManager.get(room, :participants)
      %{
        participants: ["3f8e8ef9-fea8-42da-a37d-f5f2074077ef"],
        length: 1
      }

  """
  def get(room, :participants) do
    room_state = get(room)
    %{participants: room_state.participants, length: Enum.count(room_state.participants)}
  end


  @doc """
  Check if the specified `room` exists.

  Returns `true` or `false`.

  ## Examples

      iex> RoomManager.room_exists("93a628cc-cec1-4733-b513-aff5824b02da")
      true

  """
  def room_exists(room) do
    GenServer.call(Process.whereis(__MODULE__), {:exists, room})
  end

  @doc """
  Triggers an event in the specified `room`.

  Returns `:ok` or `:noroom`.

  ## Examples

      iex> room = RoomManager.create()
      "f2d97ea1-ddaf-4949-b1bc-63766ca8d52b"
      iex> RoomManager.trigger(room, "play", nil, "93a628cc-cec1-4733-b513-aff5824b02da")
      :ok
  """
  def trigger(room, event, data, sender) do
    case room_exists(room) do
      true ->
        PubSub.broadcast(Hergetto.PubSub, room, RoomCommunicationHelper.create_event(event, data, sender))
      _ ->
        :noroom
    end
  end

  # Server

  @doc false
  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @doc false
  @impl true
  def handle_call({:join, %SessionRoom{session: session, room: room} = session_room}, _, state) do
    case Map.has_key?(state, room) do
      true ->
        GenServer.cast(Map.get(state, room), {:join, session_room})
        Logger.info("Session #{session} is joining room #{room}.")
        {:reply, session, state}

      false ->
        Logger.info("Session #{session} failed to join room #{room}.")
        {:reply, nil, state}
    end
  end

  @doc false
  @impl true
  def handle_call({:create, room}, _, state) do
    {:ok, pid} = RoomService.start_link(room)
    new_state = Map.put_new(state, room, pid)
    {:reply, room, new_state}
  end

  @doc false
  @impl true
  def handle_call({:get, room}, _, state) do
    case Map.has_key?(state, room) do
      true ->
        room_information = GenServer.call(Map.get(state, room), :get)
        {:reply, room_information, state}

      false ->
        {:reply, nil, state}
    end
  end

  @doc false
  @impl true
  def handle_call({:exists, room}, _, state) do
    {:reply, Map.has_key?(state, room), state}
  end

  @doc false
  @impl true
  def handle_cast({:leave, %SessionRoom{room: room} = session_room}, state) do
    case Map.has_key?(state, room) do
      true ->
        GenServer.cast(Map.get(state, room), {:leave, session_room})

      false ->
        nil
    end

    {:noreply, state}
  end
end
