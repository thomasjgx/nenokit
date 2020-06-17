defmodule Nenokit.Surveys.Survey.Schema do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :form_type
    field :form_data
    field :allow_guests
    field :enable_survey_subscription
    field :survey_subscription_medium
    field :survey_subscription_start
  end

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [
      :form_type,
      :form_data,
      :allow_guests,
      :enable_survey_subscription,
      :survey_subscription_medium,
      :survey_subscription_start
    ])
  end
end
