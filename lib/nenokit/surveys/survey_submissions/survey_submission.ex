defmodule Nenokit.Surveys.SurveySubmission do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.{Accounts.User, Surveys.Survey, Surveys.WorkflowStage}

  schema "survey_submissions" do
    belongs_to :user, User
    belongs_to :survey, Survey
    belongs_to :workflow_stage, WorkflowStage
    field :schema, :map

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:user_id, :survey_id, :schema, :workflow_stage_id])
    |> validate_required([:survey_id, :schema])
  end

end
