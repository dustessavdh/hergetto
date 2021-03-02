defmodule Hergetto.Repo.Migrations.AddMissingProperties do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :paused, :boolean, default: false
      add :loop, :boolean, default: false
    end
  end
end
