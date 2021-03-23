defmodule HergettoWeb.Services.ChatManager do
  use GenServer
  alias HergettoWeb.Services.Chat

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def create_chat_for(room_id) do
    GenServer.cast(Process.whereis(__MODULE__), {:create, room_id})
  end

  def chat_exists?(room_id) do
    case Process.whereis(:"chat:#{room_id}") do
      nil ->
        false

      _ ->
        true
    end
  end

  def send_message(room_id, broadcast_id, message) do
    GenServer.cast(Process.whereis(__MODULE__), {:send, {room_id, broadcast_id, message}})
  end

  def get_chat(room_id) do
    chat = case chat_exists?(room_id) do
      true ->
        GenServer.call(Process.whereis(:"chat:#{room_id}"), :get)
      _ ->
        []
    end
    Enum.reverse(chat)
  end

  def broadcast(room_id, message) do
    Phoenix.PubSub.broadcast(Hergetto.PubSub, "chat:#{room_id}", message)
  end

  def subscribe(room_id) do
    Phoenix.PubSub.subscribe(Hergetto.PubSub, "chat:#{room_id}")
  end

  # Server

  def init(_) do
    {:ok, %{}}
  end

  def handle_cast({:create, room_id}, chats) do
    case chat_exists?(room_id) do
      true ->
        {:noreply, chats}

      false ->
        {:ok, pid} = Chat.start_link(room_id)
        {:noreply, Map.put(chats, room_id, pid)}
    end
  end

  def handle_cast({:send, {room_id, broadcast_id, message}}, chats) do
    case chat_exists?(room_id) do
      true ->
        GenServer.cast(Map.get(chats, room_id), {:send, {broadcast_id, message}})
        broadcast(room_id, "sent_message")
        {:noreply, chats}

      false ->
        {:ok, pid} = Chat.start_link(room_id)
        GenServer.cast(pid, {:send, {broadcast_id, message}})
        broadcast(room_id, "sent_message")
        {:noreply, Map.put(chats, room_id, pid)}
    end
  end
end
