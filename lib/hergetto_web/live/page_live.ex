defmodule HergettoWeb.PageLive do
  use Surface.LiveView

  alias HergettoWeb.Components.Hero

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, name: "Kees van Kaas")}
  end
end
