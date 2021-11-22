defmodule Hergetto.Videos.VideoService do
  @moduledoc """
  This module is a GenServer that holds information regarding videos.
  """

  use GenServer
  require Logger

  # Client

  @doc false
  def start_link(video_service) do
    Logger.info("Videoservice with id: #{video_service} starting.")
    GenServer.start_link(__MODULE__, %{video_service: video_service, playlist: [], current: nil}, name: :"video_service:#{video_service}")
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
  def handle_call({:get, :playlist}, _, state) do
    {:reply, state.playlist, state}
  end

  @doc false
  @impl true
  def handle_call({:get, :current}, _, state) do
    {:reply, state.current, state}
  end

  @doc false
  @impl true
  def handle_cast({:set_current, video}, state) do
    {:noreply, %{state | current: video}}
  end

  @doc false
  @impl true
  def handle_cast({:delete, index}, state) do
    {:noreply, %{state | playlist: List.delete_at(state.playlist, index)}}
  end

  @doc false
  @impl true
  def handle_cast({:add, video}, state) do
    {:noreply, %{state | playlist: [video | state.playlist]}}
  end
end
