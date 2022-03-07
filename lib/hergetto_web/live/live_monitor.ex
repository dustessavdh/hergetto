defmodule HergettoWeb.LiveMonitor do
  use GenServer
  require Logger

  def monitor(socket, view_pid, view_module, meta \\ %{}) do
    pid = GenServer.whereis(__MODULE__)
    GenServer.call(pid, {:monitor, view_pid, view_module, Map.merge(meta, %{id: socket.id})})
    socket
  end

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_) do
    {:ok, %{views: %{}}}
  end

  def handle_call({:monitor, view_pid, view_module, meta}, _, %{views: views} = state) do
    Process.monitor(view_pid)
    {:reply, :ok, %{state | views: Map.put(views, view_pid, {view_module, meta})}}
  end

  def handle_info({:DOWN, _ref, :process, view_pid, reason}, state) do
    {{module, meta}, new_views} = Map.pop(state.views, view_pid)
    module.unmount(meta, reason)
    {:noreply, %{state | views: new_views}}
  end
end
