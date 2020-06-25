defmodule Nenokit.Surveys.SurveySubscribers do
  @moduledoc """
  SurveySubscriber context to handle all survey_subscriber data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias Nenokit.{Surveys, Surveys.SurveySubscriber}

  def list_survey_subscribers() do
    Repo.all(from s in SurveySubscriber, select: s, order_by: [asc: :id])
    |> Repo.preload([:user, :survey])
  end

  def list_survey_subscribers_by_survey(survey_id) do
    Repo.all(from s in SurveySubscriber, select: s, where: s.survey_id == ^survey_id, order_by: [asc: :id])
    |> Repo.preload([:user, :survey])
  end

  def fetch_survey_subscribers_to_notify(survey) do
    Repo.all(from s in SurveySubscriber, select: s, where: s.survey_id == ^survey.id and s.sent == false and s.due_date < from_now(0, "day"), order_by: [asc: :id])
    |> Repo.preload([:user, :survey])
  end

  def change_survey_subscriber(survey_subscriber \\ %SurveySubscriber{}) do
    SurveySubscriber.changeset(survey_subscriber, %{})
  end

  def create_survey_subscriber(params) do
    survey = Surveys.get_survey(params["survey_id"])
    {days_due, _} = Integer.parse(survey.schema.survey_subscription_start)
    due_date = Timex.to_naive_datetime(Timex.shift(Timex.now, days: days_due))

    params_with_due_date = params |> Map.put("due_date", due_date)
    results = 
      %SurveySubscriber{}
      |> SurveySubscriber.changeset(params_with_due_date)
      |> Repo.insert

    case results do
      {:ok, subscriber} = success ->
        subscriber_preloaded = subscriber |> Repo.preload([:user, :survey])
        case subscriber_preloaded.survey.schema.survey_subscription_medium do
          "sms" ->
            NenokitWeb.SMS.send_survey_subscription_welcome(subscriber_preloaded)
          "email" ->
            NenokitWeb.Email.send_survey_subscription_welcome(subscriber_preloaded)
        end
        success
      {:error, _changeset} = error ->
        error
    end 
  end

  def update_survey_subscriber(survey_subscriber, params) do
    survey_subscriber
    |> SurveySubscriber.changeset(params)
    |> Repo.update
  end

  def get_survey_subscriber(id) do
    Repo.get(SurveySubscriber, id)
    |> Repo.preload([:user, :survey])
  end

  def delete_survey_subscriber(survey_subscriber) do
    Repo.delete(survey_subscriber)
  end

end
