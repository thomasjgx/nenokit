defmodule Nenokit.Surveys.WorkflowStages do
  @moduledoc """
  Surveys context to handle all surveys data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias Nenokit.Surveys.WorkflowStage

  def list_workflow_stages(workflow_id) do
    Repo.all(from w in WorkflowStage, select: w, where: w.workflow_id == ^workflow_id, order_by: [asc: :id])
  end

  def change_workflow_stage(workflow_stage \\ %WorkflowStage{}) do
    WorkflowStage.changeset(workflow_stage, %{})
  end

  def create_workflow_stage(workflow_id, params) do
    workflow_stage_params = params |> Map.put("workflow_id", workflow_id)
    %WorkflowStage{}
    |> WorkflowStage.changeset(workflow_stage_params)
    |> Repo.insert
  end

  def update_workflow_stage(workflow_stage, params) do
    workflow_stage
    |> WorkflowStage.changeset(params)
    |> Repo.update
  end

  def get_workflow_stage(id) do
    Repo.get(WorkflowStage, id)
  end

  def delete_workflow_stage(workflow_stage) do
    Repo.delete(workflow_stage)
  end

end