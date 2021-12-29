defmodule HergettoWeb.PageLive do
  use Surface.LiveView

  alias HergettoWeb.Components.Hero
  alias HergettoWeb.Components.LogoIcon
  alias Hergetto.Helpers.AuthHelper

  @impl true
  def mount(_params, session, socket) do

    {
      :ok,
      socket
      |> fetch(session)
    }
  end

  def fetch(socket, session) do
    socket
    |> AuthHelper.assign_user(session)
  end
end
