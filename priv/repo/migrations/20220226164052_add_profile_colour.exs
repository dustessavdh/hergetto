defmodule Hergetto.Repo.Migrations.AddProfileColour do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profile_colour, :string
    end
  end
end
