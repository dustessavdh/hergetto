defmodule HergettoWeb.AccountLive do
  @moduledoc false
  use HergettoWeb, :live_view
  alias Hergetto.Accounts.UserHelper, as: UH

  @impl true
  def mount(_params, session, socket) do
    {:ok, prepare_assigns(socket, session, "Account")}
  end
end
