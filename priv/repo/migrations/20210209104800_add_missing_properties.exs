defmodule Hergetto.Repo.Migrations.AddMissingProperties do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :paused, :boolean
      add :loop, :boolean
    end
  end
end
