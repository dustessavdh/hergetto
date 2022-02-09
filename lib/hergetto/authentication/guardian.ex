defmodule Hergetto.Authentication.Guardian do
  @moduledoc """
  Implementation module for Guardian.
  """
  use Guardian, otp_app: :hergetto
  alias Hergetto.Accounts
  alias Hergetto.Accounts.User

  def subject_for_token(%User{:id => id}, _claims) do
    {:ok, id}
  end

  def subject_for_token(%{:profile_picture => _, :external_id => _, :provider => _} = sub, _claims) do
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :unhandled_resource_type}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user(id)
    {:ok, user}
  end

  def resource_from_claims(_claims) do
    {:error, :unhandled_resource_type}
  end
end
