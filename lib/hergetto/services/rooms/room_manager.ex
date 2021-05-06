defmodule Hergetto.Rooms.RoomManager do
  use GenServer
  require Logger

  alias Hergetto.Structs.SessionRoom
  alias Hergetto.Rooms.RoomService

  # Client

  def start_link(_) do
    Logger.info("RoomManager starting.")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Call this function to join a specific room.
  """
  def join(room) do
    session_room = %SessionRoom{session: UUID.uuid4(), room: room}
    GenServer.call(Process.whereis(__MODULE__), {:join, session_room})
  end

  @doc """
  Call this function to leave a room.
  """
  def leave(session, room) do
    GenServer.cast(Process.whereis(__MODULE__), {:leave, %SessionRoom{session: session, room: room}})
  end

  @doc """
  Call this function to create a new room.
  """
  def create() do
    room = UUID.uuid4()
    GenServer.call(Process.whereis(__MODULE__), {:create, room})
  end

  def get(room, :participants) do
    room_state = get(room)
    %{participants: room_state.participants, length: Enum.count(room_state.participants)}
  end

  def get(room) do
    GenServer.call(Process.whereis(__MODULE__), {:get, room})
  end

  @doc """
  Call this function to check if the specified room exists.
  """
  def room_exists(room) do
    GenServer.call(Process.whereis(__MODULE__), {:exists, room})
  end

  # Server

  @impl true
  def init(_) do
    {:ok, %{}}
  end

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

  @impl true
  def handle_call({:create, room}, _, state) do
    {:ok, pid} = RoomService.start_link(room)
    new_state = Map.put_new(state, room, pid)
    {:reply, room, new_state}
  end

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

  @impl true
  def handle_call({:exists, room}, _, state) do
    {:reply, Map.has_key?(state, room), state}
  end

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
