defmodule Hergetto.Repo.Migrations.AddUuidToRoom do
  use Ecto.Migration

  def change do
  	alter table(:rooms) do
  		add :uuid, :uuid
  	end
  end
end
