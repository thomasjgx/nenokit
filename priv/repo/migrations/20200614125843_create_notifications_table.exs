defmodule Nenokit.Repo.Migrations.CreateNotificationsTable do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :content, :string, null: false
      add :module, :string, null: false
      add :record_id, :integer
      add(:user_id, references(:users), null: false)
      add :read, :boolean, default: false

      timestamps()
    end
  end
end
