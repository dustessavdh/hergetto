defmodule Hergetto.Users do
  alias Hergetto.User
  alias Hergetto.Repo

  def get(uid, :external_id) do
    Repo.get_by(User, external_id: uid)
  end

  def create_user(email, profile_picture, external_id) do
    %User{email: email, profile_picture: profile_picture, external_id: external_id}
    |> Repo.insert()
  end
end
