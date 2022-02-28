defmodule HergettoWeb.PageLive do
  @moduledoc false
  use HergettoWeb, :live_view
  alias HergettoWeb.Components.Avatar
  alias HergettoWeb.Components.Hero

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> prepare_assigns(session, "Hergetto")
    }
  end
end
