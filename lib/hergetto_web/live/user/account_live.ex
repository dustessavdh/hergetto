defmodule HergettoWeb.AccountLive do
  @moduledoc false
  use HergettoWeb, :live_view
  alias HergettoWeb.Components.Avatar

  @impl true
  def mount(_params, session, socket) do
    {:ok, prepare_assigns(socket, session, "Account")}
  end
end
