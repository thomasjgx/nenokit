defmodule NenokitWeb.SurveyController do
  use NenokitWeb, :controller

  alias Nenokit.{Surveys, Surveys.SurveySubmissions}

  def view(conn, %{"id" => survey_id, "data" => data}) do
    survey = Surveys.get_survey(survey_id)
    render(conn, "form.html", survey: survey, data: data)
  end

  def submit(conn, params) do
    survey = Surveys.get_survey(params["id"])
    user_id =
      case params["data"] do
        nil ->
          nil
        data ->
          user_id = Base.decode64!(data)
          IO.inspect user_id
          user_id
      end

    workflow_stage_id =
      case survey.schema.submission_stage do
        nil ->
          nil
        stage_id ->
          stage_id
      end

    submission_params = %{
      "user_id" => user_id,
      "survey_id" => survey.id,
      "schema" => %{"form_data" => params},
      "workflow_stage_id" => workflow_stage_id
    }
    case SurveySubmissions.create_survey_submission(submission_params) do
      {:ok, _survey_submission} ->
        render(conn, "submitted.html", survey: survey)
      {:error, changeset} ->
        render(conn, "form.html", survey: survey, changeset: changeset, page: nil, data: params["data"])
    end
  end

end
