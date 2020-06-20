defmodule Nenokit.Surveys.SurveySubscriber do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.{Accounts.User, Surveys.Survey, Surveys.SurveySubmission}

  schema "survey_subscribers" do
    field :subscription_notes, :string
    field :sent, :boolean, default: false
    field :submitted, :boolean, default: false
    field :due_date, :naive_datetime
    belongs_to :user, User
    belongs_to :survey, Survey
    belongs_to :survey_submission, SurveySubmission

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:user_id, :survey_id, :subscription_notes, :sent, :submitted, :due_date])
    |> validate_required([:user_id, :survey_id, :due_date])
  end

end
