defmodule Nenokit.Repo.Migrations.AlterSurveySubscribersTableAddDueDate do
  use Ecto.Migration

  def change do
    alter table(:survey_subscribers) do
      add :due_date, :naive_datetime
    end
  end
end
