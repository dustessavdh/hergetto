defmodule Hergetto.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :playback_position, :integer, default: 0
      add :playback_rate, :float, default: 1.0
      add :current_video, :string, default: "https://www.youtube.com/watch?v=Fkxox9xgL1U"
      add :playlist, {:array, :string}, default: []

      timestamps()
    end
  end
end
