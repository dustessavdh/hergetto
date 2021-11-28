defmodule Hergetto.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string
      add :profile_picture, :string
      add :external_id, :string

      timestamps()
    end
  end
end
