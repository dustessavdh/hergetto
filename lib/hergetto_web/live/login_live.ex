defmodule HergettoWeb.LoginLive do
  @moduledoc false
  use HergettoWeb, :live_view
  alias Surface.Components.Link
  alias Hergetto.Helpers.AuthHelper
  alias HergettoWeb.Components.LogoIcon

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, page_title: "Login")}
  end
end
