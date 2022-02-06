defmodule Hergetto.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    field :profile_picture, :string
    field :external_id, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :profile_picture, :external_id])
    |> validate_required([:email, :profile_picture, :external_id])
  end
end
