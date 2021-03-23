defmodule HergettoWeb.Services.Chat do
  use GenServer
  require Logger

  # Client

  def start_link(room_id) do
    Logger.info("Starting chatroom: chat:#{room_id}")
    GenServer.start_link(__MODULE__, :ok, name: :"chat:#{room_id}")
  end

  # Server

  def init(_) do
    {:ok, []}
  end

  def handle_call(:get, _, state) do
    {:reply, state, state}
  end

  def handle_cast({:send, {broadcast_id, message}}, state) do
    message = %{sender: broadcast_id, message: message}
    {:noreply, [message | state]}
  end
end
