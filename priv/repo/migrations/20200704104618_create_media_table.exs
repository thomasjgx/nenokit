defmodule Nenokit.Repo.Migrations.CreateMediaTable do
  use Ecto.Migration

  def change do
    create table(:media) do
      add :name, :string, null: false
      add :file, :string, null: false

      timestamps()
    end
  end
end
