defmodule Nenokit.Repo.Migrations.CreateMessagesTable do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string, null: false
      add(:sender_user_id, references(:users), null: false)
      add(:receiver_user_id, references(:users), null: false)
      add :read, :boolean, default: false

      timestamps()
    end
  end
end
