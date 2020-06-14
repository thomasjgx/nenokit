defmodule Nenokit.Repo.Migrations.CreateSettingsTable do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :configuration, :map, null: false
      add :appearance, :map, null: false

      timestamps()
    end
  end
end
