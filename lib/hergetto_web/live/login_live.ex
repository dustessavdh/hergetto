defmodule HergettoWeb.LoginLive do
  use Surface.LiveView
  alias Surface.Components.Link

  @impl true
  def mount(_params, _session, socket) do
    {:ok, fetch(socket)}
  end

  def fetch(socket) do
    socket
  end
end
