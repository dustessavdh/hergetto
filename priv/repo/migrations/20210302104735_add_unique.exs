defmodule Hergetto.Repo.Migrations.AddUnique do
  use Ecto.Migration

  def change do
    create unique_index(:rooms, [:uuid])
  end
end
