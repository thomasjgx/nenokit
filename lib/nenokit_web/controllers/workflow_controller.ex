defmodule NenokitWeb.WorkflowController do
  use NenokitWeb, :controller

  alias Nenokit.{Surveys, Surveys.Workflows, Surveys.WorkflowStages, Surveys.SurveySubmissions}

  def show(conn, %{"id" => workflow_id}) do
    workflow = Workflows.get_workflow(workflow_id)
    submissions = SurveySubmissions.list_survey_submissions_by_workflow(workflow.id)
    stages = WorkflowStages.list_workflow_stages(workflow_id)
    render(conn, "show.html", workflow: workflow, submissions: submissions, stages: stages)
  end

  def filter(conn, %{"stage_id" => stage_id}) do
    stage = WorkflowStages.get_workflow_stage(stage_id)
    workflow = Workflows.get_workflow(stage.workflow_id)
    submissions = SurveySubmissions.list_survey_submissions_by_stage(stage_id)
    stages = WorkflowStages.list_workflow_stages(workflow.id)
    render(conn, "show.html", workflow: workflow, submissions: submissions, stages: stages)
  end

  def submission(conn, %{"submission_id" => submission_id}) do
    submission = SurveySubmissions.get_survey_submission(submission_id)
    survey = Surveys.get_survey(submission.survey_id)
    stage = WorkflowStages.get_workflow_stage(submission.workflow_stage_id)
    stages = WorkflowStages.list_workflow_stages(stage.workflow_id)
    render(conn, "submission.html", survey: survey, submission: submission, stages: stages)
  end

  def move_submission(conn, %{"submission_id" => submission_id, "stage_id" => stage_id}) do
    submission = SurveySubmissions.get_survey_submission(submission_id)
    case SurveySubmissions.update_survey_submission(submission, %{"workflow_stage_id" => stage_id}) do
      {:ok, _} ->
        conn
        |> redirect(to: Routes.workflow_path(conn, :submission, submission))
      {:error, _changeset} ->
        conn
        |> redirect(to: Routes.workflow_path(conn, :submission, submission))
    end
  end

end
