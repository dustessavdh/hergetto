defmodule HergettoWeb.RoomsLive do
  @moduledoc false
  use HergettoWeb, :live_view

  import HergettoWeb.Presence

  @topic "Hergetto:rooms"

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> prepare_assigns(session, "Rooms")
      |> start_user_presence(@topic, self())
    }
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", topic: @topic, payload: diff}, socket) do
    handle_user_presence_diff(socket, diff)
  end
end
