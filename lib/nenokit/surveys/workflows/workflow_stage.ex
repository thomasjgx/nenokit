defmodule Nenokit.Surveys.WorkflowStage do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Surveys.Workflow

  schema "workflows" do
    field :name, :string
    field :description, :string
    field :settings, :map
    belongs_to :workflow, Workflow

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :description, :settings, :workflow_id])
    |> validate_required([:name, :description, :workflow_id])
  end

end
