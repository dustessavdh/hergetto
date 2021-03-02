defmodule Hergetto.Repo.Migrations.AddPeople do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
  		add :owner, :uuid
      add :participants, {:array, :uuid}, default: []
  	end
  end
end
