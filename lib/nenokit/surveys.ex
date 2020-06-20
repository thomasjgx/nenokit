defmodule Nenokit.Surveys do
  @moduledoc """
  Surveys context to handle all surveys data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias __MODULE__.Survey

  def list_surveys() do
    Repo.all(from s in Survey, select: s, order_by: [asc: :id])
  end
  
  def list_surveys_with_subscription_enabled() do
    Repo.all(from s in Survey, select: s, where: fragment("schema->'enable_survey_subscription' is not null"), where: fragment(~s|schema @> '{"enable_survey_subscription": "yes"}'|), order_by: [asc: :id])
  end

  def change_survey(survey \\ %Survey{}) do
    Survey.changeset(survey, %{})
  end

  def create_survey(params) do
    %Survey{}
    |> Survey.changeset(params)
    |> Repo.insert
  end

  def update_survey(survey, params) do
    survey
    |> Survey.changeset(params)
    |> Repo.update
  end

  def get_survey(id) do
    Repo.get(Survey, id)
  end

  def delete_survey(survey) do
    Repo.delete(survey)
  end

end
