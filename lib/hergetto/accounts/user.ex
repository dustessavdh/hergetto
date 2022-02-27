defmodule Hergetto.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :external_id, :string
    field :profile_picture, :string
    field :profile_colour, :string
    field :provider, :string
    field :email, :string
    field :username, :string
    field :tag, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:profile_picture, :profile_colour, :external_id, :provider, :email, :username, :tag])
    |> validate_required([:profile_picture, :profile_colour, :external_id, :provider, :email, :username, :tag])
    |> unique_constraint([:username, :tag], name: :username_with_tag_index, message: "username and tag must be unique")
    |> validate_format(:email, ~r/^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+$/)
    |> validate_length(:tag, is: 4)
    |> validate_inclusion(:provider, ["google"])
    |> validate_profile_picture()
  end

  defp validate_profile_picture(changeset, default_profile_picture \\ "/assets/avatars/default.svg") do
    case String.length(Map.get(changeset.changes, :profile_pciture, "")) > 255 do
      true ->
        put_change(changeset, :profile_picture, default_profile_picture)
      false ->
        changeset
    end
  end
end
