defmodule Nenokit.Repo.Migrations.CreateRoleWorkflowsTable do
  use Ecto.Migration

  def change do
    create table(:role_workflows) do
      add(:role_id, references(:roles), null: false)
      add(:workflow_id, references(:workflows), null: false)

      timestamps()
    end

    create(
      unique_index(
        :role_workflows,
        [:role_id, :workflow_id],
        name: "uidx_role_id_workflow_id"
      )
    )
  end
end
