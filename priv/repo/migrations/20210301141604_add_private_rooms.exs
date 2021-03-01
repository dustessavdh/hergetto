defmodule Hergetto.Repo.Migrations.AddPrivateRooms do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
  		add :private, :boolean, default: true
  	end
  end
end
