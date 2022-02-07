defmodule Hergetto.Users do
  @moduledoc false
  alias Hergetto.User
  alias Hergetto.Repo

  def get(uid, :external_id) do
    Repo.get_by(User, external_id: uid)
  end

  def get(id, :id) do
    Repo.get_by(User, id: id)
  end

  def create_user(email, token, profile_picture, external_id, provider) do
    %User{
      email: email,
      token: token,
      profile_picture: profile_picture,
      external_id: external_id,
      provider: provider
    }
    |> Repo.insert()
  end
end
