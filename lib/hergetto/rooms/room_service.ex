defmodule Hergetto.Rooms.RoomService do
  @moduledoc """
  This module represents a room, and manages the chat and video service.
  """

  use GenServer
  require Logger

  # Client

  @doc false
  def start_link(room) do
    Logger.info("Roomservice with id: #{room} starting.")
    GenServer.start_link(__MODULE__, %{room: room, participants: [], video_service: nil}, name: :"roomservice:#{room}")
  end

  # Server

  @doc false
  @impl true
  def init(state) do
    {:ok, state}
  end

  @doc false
  @impl true
  def handle_cast({:join, session}, state) do
    Logger.info("Session #{session} joined room #{state.room_id}")
    {:noreply, %{state | participants: [session | state.participants]}}
  end

  @doc false
  @impl true
  def handle_cast({:leave, session}, state) do
    Logger.info("Session #{session} left room #{state.room_id}")
    {:noreply, %{state | participants: Enum.filter(state.participants, fn p -> p != session end)}}
  end

  @doc false
  @impl true
  def handle_cast({:video_service, video_service}, state) do
    Logger.info("Video service #{video_service} added to room #{state.room}")
    {:noreply, %{state | video_service: video_service}}
  end

  @doc false
  @impl true
  def handle_call({:get, :all}, _, state) do
    {:reply, state, state}
  end

  @doc false
  @impl true
  def handle_call({:get, :participants}, _, state) do
    {:reply, state.participants, state}
  end

  @doc false
  @impl true
  def handle_call({:get, :video_service}, _, state) do
    {:reply, state.video_service, state}
  end
end
