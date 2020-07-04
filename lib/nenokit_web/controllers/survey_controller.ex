defmodule NenokitWeb.SurveyController do
  use NenokitWeb, :controller

  alias Nenokit.{Surveys, Surveys.SurveySubmissions}

  @spec view(Plug.Conn.t(), map) :: Plug.Conn.t()
  def view(conn, %{"id" => survey_id, "data" => data}) do
    survey = Surveys.get_survey(survey_id)
    render(conn, "form.html", survey: survey, data: data)
  end

  def view(conn, %{"id" => survey_id}) do
    survey = Surveys.get_survey(survey_id)
    render(conn, "form.html", survey: survey, data: nil)
  end

  @spec submit(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def submit(conn, params) do
    survey = Surveys.get_survey(params["id"])
    user_id =
      case params["data"] do
        nil ->
          conn.assigns.current_user.id
        "" ->
          conn.assigns.current_user.id
        data ->
          user_id = Base.decode64!(data)
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
