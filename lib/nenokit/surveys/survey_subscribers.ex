defmodule Nenokit.Surveys.SurveySubscribers do
  @moduledoc """
  SurveySubscriber context to handle all survey_subscriber data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias Nenokit.Surveys.SurveySubscriber

  def list_survey_subscribers() do
    Repo.all(from s in SurveySubscriber, select: s, order_by: [asc: :id])
    |> Repo.preload([:user, :survey])
  end

  def list_survey_subscribers_by_survey(survey_id) do
    Repo.all(from s in SurveySubscriber, select: s, where: s.survey_id == ^survey_id, order_by: [asc: :id])
    |> Repo.preload([:user, :survey])
  end

  def change_survey_subscriber(survey_subscriber \\ %SurveySubscriber{}) do
    SurveySubscriber.changeset(survey_subscriber, %{})
  end

  def create_survey_subscriber(params) do
    %SurveySubscriber{}
    |> SurveySubscriber.changeset(params)
    |> Repo.insert
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