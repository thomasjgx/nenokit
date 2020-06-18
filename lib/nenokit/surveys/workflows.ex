defmodule Nenokit.Surveys.Workflows do
  @moduledoc """
  Workflows context to handle all workflows data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias Nenokit.{Surveys.Workflow, Roles.RoleWorkflow, Roles.RoleUser}

  def list_workflows() do
    Repo.all(from w in Workflow, select: w, order_by: [asc: :id])
  end

  def list_workflows_by_user(user_id) do
    Repo.all(from w in Workflow, select: w, join: rw in RoleWorkflow, on: w.id == rw.workflow_id, join: ru in RoleUser, on: rw.role_id == ru.user_id, where: ru.user_id == ^user_id, order_by: [asc: :id])
  end

  def change_workflow(workflow \\ %Workflow{}) do
    Workflow.changeset(workflow, %{})
  end

  def create_workflow(params) do
    %Workflow{}
    |> Workflow.changeset(params)
    |> Repo.insert
  end

  def update_workflow(workflow, params) do
    workflow
    |> Workflow.changeset(params)
    |> Repo.update
  end

  def get_workflow(id) do
    Repo.get(Workflow, id)
  end

  def delete_workflow(workflow) do
    Repo.delete(workflow)
  end

end