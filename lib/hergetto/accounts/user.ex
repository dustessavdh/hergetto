defmodule Hergetto.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :external_id, :string
    field :profile_picture, :string
    field :provider, :string
    field :tag, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:profile_picture, :external_id, :provider, :username, :tag])
    |> validate_required([:profile_picture, :external_id, :provider, :username, :tag])
  end
end
