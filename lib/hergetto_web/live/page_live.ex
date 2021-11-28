defmodule HergettoWeb.PageLive do
  use Surface.LiveView

  alias HergettoWeb.Components.Hero

  @impl true
  def mount(_params, session, socket) do
    {:ok, fetch(socket, session)}
  end

  def fetch(socket, session) do
    case Map.has_key?(session, "user") do
      true ->
        socket
        |> assign(user: Map.get(session, "user"))
      false ->
        socket
        |> assign(user: nil)
    end
  end
end
