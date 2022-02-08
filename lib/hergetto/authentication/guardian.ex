defmodule Hergetto.Authentication.Guardian do
  @moduledoc """
  Implementation module for Guardian.
  """
  use Guardian, otp_app: :hergetto
  alias Hergetto.User

  def subject_for_token(%User{:id => id}, _claims) do
    {:ok, id}
  end

  def subject_for_token(_, _) do
    {:error, :unhandled_resource_type}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Hergetto.Users.get(id, :id)
    {:ok, user}
  end

  def resource_from_claims(_claims) do
    {:error, :unhandled_resource_type}
  end
end
