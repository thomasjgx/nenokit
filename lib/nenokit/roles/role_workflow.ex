defmodule Nenokit.Roles.RoleWorkflow do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Roles.Role
  alias Nenokit.Surveys.Workflow

  schema "role_workflows" do
    belongs_to :role, Role
    belongs_to :workflow, Workflow

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:role_id, :workflow_id])
    |> validate_required([:role_id, :workflow_id])
    |> unique_constraint(:role_workflows, name: :uidx_role_id_workflow_id, message: "has already been taken")
  end
end
