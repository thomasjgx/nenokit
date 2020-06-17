defmodule Nenokit.Surveys.SurveySubmissions do
  @moduledoc """
  SurveySubmissions context to handle all survey_submissions data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias Nenokit.Surveys.{SurveySubmission, WorkflowStage, Workflow}

  def list_survey_submissions_by_survey(survey_id) do
    Repo.all(from s in SurveySubmission, select: s, where: s.survey_id == ^survey_id, order_by: [desc: :id])
    |> Repo.preload(:user)
  end

  def list_survey_submissions_by_stage(workflow_stage_id) do
    Repo.all(from s in SurveySubmission, select: s, where: s.workflow_stage_id == ^workflow_stage_id, order_by: [desc: :id])
    |> Repo.preload([:survey, :user, :workflow_stage])
  end

  def list_survey_submissions_by_workflow(workflow_id) do
    Repo.all(from s in SurveySubmission, select: s, join: ws in WorkflowStage, on: s.workflow_stage_id == ws.id, join: w in Workflow, on: ws.workflow_id == w.id, where: w.id == ^workflow_id, order_by: [desc: :id])
    |> Repo.preload([:survey, :user, :workflow_stage])
  end

  def change_survey_submission(survey_submission \\ %SurveySubmission{}) do
    SurveySubmission.changeset(survey_submission, %{})
  end

  def create_survey_submission(params) do
    %SurveySubmission{}
    |> SurveySubmission.changeset(params)
    |> Repo.insert
  end

  def update_survey_submission(survey_submission, params) do
    survey_submission
    |> SurveySubmission.changeset(params)
    |> Repo.update
  end

  def get_survey_submission(id) do
    Repo.get(SurveySubmission, id)
    |> Repo.preload([:user, :workflow_stage])
  end

  def delete_survey_submission(survey_submission) do
    Repo.delete(survey_submission)
  end

end