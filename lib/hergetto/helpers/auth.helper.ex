defmodule Hergetto.Helpers.AuthHelper do
  alias Phoenix.LiveView

  def assign_user(socket, session) do
    case Map.has_key?(session, "user") do
      true ->
        socket
        |> LiveView.assign(user: Map.get(session, "user"))
      false ->
        socket
        |> LiveView.assign(user: nil)
    end
  end
end
