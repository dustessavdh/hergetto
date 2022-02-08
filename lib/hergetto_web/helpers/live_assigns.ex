defmodule HergettoWeb.Helpers.LiveAssigns do
  @moduledoc """
  This module provides a way to set the basic assigns for a liveview.
  """
  import Phoenix.LiveView
  alias Hergetto.Authentication.Guardian

  @claims %{"typ" => "access"}
  @token_key "guardian_default_token"

  @doc """
  Set basic assigns for a liveview.
  
  It sets the following assigns:
  - current_user
  - page_title
  - meta_attrs
  
  ## Example:
  
  ```elixir
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> prepare_assigns(session, "Example Title", [%{name: "og:description", content: "You can use it like this!"}])
    }
  end
  ```
  """
  def prepare_assigns(socket, session, page_title, meta_attrs \\ []) do
    {:ok, user} = get_current_user(session)

    socket
    |> assign(
      current_user: user,
      page_title: page_title,
      meta_attrs: meta_attrs
    )
  end

  defp get_current_user(%{@token_key => token}) do
    case Guardian.decode_and_verify(token, @claims) do
      {:ok, claims} ->
        Guardian.resource_from_claims(claims)

      _ ->
        {:ok, nil}
    end
  end

  defp get_current_user(_) do
    {:ok, nil}
  end
end
