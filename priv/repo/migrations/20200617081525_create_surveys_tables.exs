defmodule Nenokit.Repo.Migrations.CreateSurveysTables do
  use Ecto.Migration

  def change do
    create table(:surveys) do
      add :name, :string, null: false
      add :description, :string
      add :schema, :map

      timestamps()
    end

    create table(:workflows) do
      add :name, :string, null: false
      add :description, :string
      add :settings, :map

      timestamps()
    end

    create table(:workflow_stages) do
      add :name, :string, null: false
      add :description, :string
      add :settings, :map
      add(:workflow_id, references(:workflows), null: false)

      timestamps()
    end

    create table(:survey_submissions) do
      add(:survey_id, references(:surveys), null: false)
      add(:user_id, references(:users))
      add(:workflow_stage_id, references(:workflow_stages))
      add :schema, :map

      timestamps()
    end

    create table(:survey_subscribers) do
      add(:user_id, references(:users), null: false)
      add(:survey_id, references(:surveys), null: false)
      add :subscription_notes, :string
      add :sent, :boolean, default: false
      add :submitted, :boolean, default: false
      add(:survey_submission_id, references(:survey_submissions))

      timestamps()
    end
  end
end
