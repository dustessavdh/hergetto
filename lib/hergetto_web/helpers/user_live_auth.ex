defmodule HergettoWeb.Helpers.UserLiveAuth do
  @moduledoc """
  Provides functions for user authentication in liveviews
  """
  alias Phoenix.LiveView
  alias Hergetto.Users

  @doc """
  Gets the user from the session and assigns it to the socket
  """
  def fetch_current_user(socket, session) do
    case Map.has_key?(session, "user_token") do
      true ->
        socket
        |> LiveView.assign_new(:current_user, fn ->
          Users.get(Map.get(session, "user_token"), :external_id)
        end)

      false ->
        socket
        |> LiveView.assign_new(:current_user, fn -> nil end)
    end
  end
end
