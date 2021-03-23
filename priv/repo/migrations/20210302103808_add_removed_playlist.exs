defmodule Hergetto.Repo.Migrations.AddRemovedPlaylist do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :played_playlist, {:array, :string}, default: []
    end
  end
end
