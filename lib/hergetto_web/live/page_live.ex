defmodule HergettoWeb.PageLive do
  @moduledoc false
  use HergettoWeb, :live_view
  alias HergettoWeb.Components.Hero
  alias HergettoWeb.Components.LogoIcon
  alias HergettoWeb.Helpers.UserLiveAuth

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      UserLiveAuth.fetch_current_user(socket, session)
    }
  end

  # @impl true
  # def mount(_params, session, socket) do
  #   {
  #     :ok,
  #     socket
  #     |> fetch(session)
  #     |> assign(room: %{:name => "test", :private? => true})
  #   }
  # end

  # def fetch(socket, session) do
  #   socket
  #   |> AuthHelper.assign_user(session)
  # end
end
