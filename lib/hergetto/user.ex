defmodule Hergetto.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    field :provider, :string
    field :profile_picture, :string
    field :external_id, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :provider, :profile_picture, :external_id, :token])
    |> validate_required([:email, :provider, :profile_picture, :external_id, :token])
  end
end
