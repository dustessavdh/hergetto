defmodule Hergetto.Repo.Migrations.AddUsernameConstraints do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:username, :tag], name: :username_with_tag_index)
  end
end
