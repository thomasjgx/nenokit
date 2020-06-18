defmodule Nenokit.Surveys.Workflow.Settings do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :survey_id
  end

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [
      :survey_id
    ])
  end
end
