defmodule HergettoWeb.LoginLive do
  @moduledoc false
  use HergettoWeb, :live_view
  alias Surface.Components.Link
  alias HergettoWeb.Components.LogoIcon

  @impl true
  def mount(_params, session, socket) do
    {:ok, prepare_assigns(socket, session, "Login")}
  end
end
