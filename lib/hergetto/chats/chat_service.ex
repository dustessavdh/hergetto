defmodule Hergetto.Chats.ChatService do
  @moduledoc """
  This module is a GenServer representing a chat.
  """

  use GenServer
  require Logger

  # Client

  @doc false
  def start_link({chat_service, room}) do
    Logger.info("Chatservice with id: #{chat_service} starting.")

    GenServer.start_link(__MODULE__, %{chat_service: chat_service, room: room, messages: []},
      name: :"chat_service:#{chat_service}"
    )
  end

  # Server

  @doc false
  @impl true
  def init(state) do
    {:ok, state}
  end

  @doc false
  @impl true
  def handle_call({:get, :all}, _, state) do
    {:reply, state, state}
  end

  @doc false
  @impl true
  def handle_call({:get, :messages}, _, state) do
    {:reply, state.messages, state}
  end

  @doc false
  @impl true
  def handle_call({:get, :room}, _, state) do
    {:reply, state.room, state}
  end

  @doc false
  @impl true
  def handle_cast({:send, message}, state) do
    {:noreply, %{state | messages: [message | state.messages]}}
  end
end
