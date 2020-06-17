defmodule NenokitWeb.SurveyController do
  use NenokitWeb, :controller

  alias Nenokit.{Surveys, Surveys.SurveySubmissions}

  def view(conn, %{"id" => survey_id}) do
    survey = Surveys.get_survey(survey_id)
    render(conn, "form.html", survey: survey)
  end

  def submit(conn, params) do
    survey = Surveys.get_survey(params["id"])
    user_id =
      case conn.assigns.current_user do
        nil ->
          nil
        user ->
          user.id
      end
    submission_params = %{
      "user_id" => user_id,
      "survey_id" => survey.id,
      "schema" => %{"form_data" => params}
    }
    case SurveySubmissions.create_survey_submission(submission_params) do
      {:ok, _survey_submission} ->
        render(conn, "submitted.html", survey: survey)
      {:error, changeset} ->
        render(conn, "form.html", survey: survey, changeset: changeset, page: nil)
    end
  end

end