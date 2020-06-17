defmodule NenokitWeb.AdminSurveyWorkflowController do
  use NenokitWeb, :controller

  alias Nenokit.{Surveys.Workflows, Surveys.WorkflowStages, AuditTrails}

  def index(conn, _params) do
    workflows = Workflows.list_workflows
    render(conn, "index.html", workflows: workflows)
  end

  def new(conn, _params) do
    changeset = Workflows.change_workflow
    render(conn, "new.html", changeset: changeset, workflow: nil)
  end

  def create(conn, %{"workflow" => params}) do
    case Workflows.create_workflow(params) do
      {:ok, workflow} ->
        # Log action in audit trial
        current_user = conn.assigns.current_user
        AuditTrails.create_audit_trail(current_user, %{"action" => "Created a new workflow", "module" => "admin_workflow", "record_id" => workflow.id})

        conn
        |> put_flash(:success, "Workflow created successfully")
        |> redirect(to: Routes.admin_survey_workflow_path(conn, :show, workflow))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, workflow: nil)
    end
  end

  def show(conn, %{"id" => workflow_id}) do
    workflow = Workflows.get_workflow(workflow_id)
    stages = WorkflowStages.list_workflow_stages(workflow.id)
    render(conn, "show.html", workflow: workflow, stages: stages)
  end

  def edit(conn, %{"id" => workflow_id}) do
    workflow = Workflows.get_workflow(workflow_id)
    changeset = Workflows.change_workflow(workflow)
    render(conn, "edit.html", workflow: workflow, changeset: changeset)
  end

  def update(conn, %{"id" => workflow_id, "workflow" => workflow_params}) do
    workflow = Workflows.get_workflow(workflow_id)
    case Workflows.update_workflow(workflow, workflow_params) do
      {:ok, workflow} ->
        # Log action in audit trial
        current_user = conn.assigns.current_user
        AuditTrails.create_audit_trail(current_user, %{"action" => "Updated a workflow", "module" => "admin_workflow", "record_id" => workflow.id})

        conn
        |> put_flash(:info, "Workflow updated successfully.")
        |> redirect(to: Routes.admin_survey_workflow_path(conn, :show, workflow))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", workflow: workflow, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => workflow_id}) do
    workflow = Workflows.get_workflow(workflow_id)
    {:ok, _workflow} = Workflows.delete_workflow(workflow)

    # Log action in audit trial
    current_user = conn.assigns.current_user
    AuditTrails.create_audit_trail(current_user, %{"action" => "Deleted a workflow", "module" => "admin_workflow", "record_id" => workflow.id})

    conn
    |> put_flash(:info, "Workflow deleted successfully.")
    |> redirect(to: Routes.admin_survey_workflow_path(conn, :index))
  end
end
