defmodule Nenokit.Repo.Migrations.CreateAuditTrailsTable do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS timescaledb", "SELECT 1"

    create table(:audit_trails, primary_key: false) do
      add :action, :string, null: false
      add :module, :string, null: false
      add :record_id, :integer
      add(:user_id, references(:users), null: false)
      add :time, :timestamp, null: false
    end

    execute("SELECT create_hypertable('audit_trails', 'time')", "SELECT 1")
  end
end
