defmodule Hergetto.Authentication.Guardian do
  use Guardian, otp_app: :hergetto

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end
  def subject_for_token(_, _) do
    {:error, :unhandled_resource_type}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Hergetto.Users.get(id, :id)
    {:ok,  user}
  end
  def resource_from_claims(_claims) do
    {:error, :unhandled_resource_type}
  end
end
