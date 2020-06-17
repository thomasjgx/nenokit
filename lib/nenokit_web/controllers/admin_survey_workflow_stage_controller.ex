defmodule NenokitWeb.AdminSurveyWorkflowStageController do
  use NenokitWeb, :controller

  alias Nenokit.{Surveys.Workflows, Surveys.WorkflowStages, AuditTrails}

  def new(conn, %{"workflow_id" => workflow_id}) do
    workflow = Workflows.get_workflow(workflow_id)
    changeset = WorkflowStages.change_workflow_stage
    render(conn, "new.html", changeset: changeset, workflow: workflow)
  end

  def create(conn, %{"workflow_id" => workflow_id, "workflow_stage" => params}) do
    workflow = Workflows.get_workflow(workflow_id)
    case WorkflowStages.create_workflow_stage(workflow_id, params) do
      {:ok, workflow_stage} ->
        # Log action in audit trial
        current_user = conn.assigns.current_user
        AuditTrails.create_audit_trail(current_user, %{"action" => "Created a new workflow stage", "module" => "admin_workflow_stage", "record_id" => workflow_stage.id})

        conn
        |> put_flash(:success, "Workflow stage created successfully")
        |> redirect(to: Routes.admin_survey_workflow_path(conn, :show, workflow))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, workflow: workflow)
    end
  end

  def edit(conn, %{"workflow_id" => workflow_id, "id" => workflow_stage_id}) do
    workflow = Workflows.get_workflow(workflow_id)
    workflow_stage = WorkflowStages.get_workflow_stage(workflow_stage_id)
    changeset = WorkflowStages.change_workflow_stage(workflow_stage)
    render(conn, "edit.html", workflow: workflow, workflow_stage: workflow_stage, changeset: changeset)
  end

  def update(conn, %{"workflow_id" => workflow_id, "id" => workflow_stage_id, "workflow_stage" => workflow_stage_params}) do
    workflow = Workflows.get_workflow(workflow_id)
    workflow_stage = WorkflowStages.get_workflow_stage(workflow_stage_id)
    case WorkflowStages.update_workflow_stage(workflow_stage, workflow_stage_params) do
      {:ok, workflow_stage} ->
        # Log action in audit trial
        current_user = conn.assigns.current_user
        AuditTrails.create_audit_trail(current_user, %{"action" => "Updated a workflow stage", "module" => "admin_workflow_stage", "record_id" => workflow_stage.id})

        conn
        |> put_flash(:info, "Workflow stage updated successfully.")
        |> redirect(to: Routes.admin_survey_workflow_path(conn, :show, workflow_stage.workflow_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", workflow: workflow, workflow_stage: workflow_stage, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => workflow_stage_id}) do
    workflow_stage = WorkflowStages.get_workflow_stage(workflow_stage_id)
    {:ok, _workflow_stage} = WorkflowStages.delete_workflow_stage(workflow_stage)

    # Log action in audit trial
    current_user = conn.assigns.current_user
    AuditTrails.create_audit_trail(current_user, %{"action" => "Deleted a workflow stage", "module" => "admin_workflow_stage", "record_id" => workflow_stage.id})

    conn
    |> put_flash(:info, "Workflow deleted successfully.")
    |> redirect(to: Routes.admin_survey_workflow_path(conn, :show, workflow_stage.workflow_id))
  end
end
