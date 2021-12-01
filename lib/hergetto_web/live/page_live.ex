defmodule HergettoWeb.PageLive do
  use Surface.LiveView

  alias HergettoWeb.Components.Hero

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, room_name: "Kees van Kaas", room_private?: true, user: "test")}
  end
end
