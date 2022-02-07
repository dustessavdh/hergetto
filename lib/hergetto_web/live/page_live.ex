defmodule HergettoWeb.PageLive do
  @moduledoc false
  use HergettoWeb, :live_view
  alias HergettoWeb.Components.Hero
  alias HergettoWeb.Components.LogoIcon
  alias HergettoWeb.Helpers.UserLiveAuth

  @claims %{"typ" => "access"}
  @token_key "guardian_default_token"

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> prepare_assigns(session, "Hergetto", [%{name: "description", content: "sheesh!"}])
    }
  end
end
