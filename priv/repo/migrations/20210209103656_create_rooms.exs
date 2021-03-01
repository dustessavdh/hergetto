defmodule Hergetto.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :playback_position, :integer
      add :playback_rate, :float
      add :current_video, :string
      add :playlist, {:array, :string}, default: []

      timestamps()
    end
  end
end
