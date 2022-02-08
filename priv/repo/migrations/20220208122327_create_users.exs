defmodule Hergetto.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :profile_picture, :string
      add :external_id, :string
      add :provider, :string
      add :username, :string
      add :tag, :string

      timestamps()
    end
  end
end
