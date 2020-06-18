defmodule NenokitWeb.Plugs.LoadWorkflows do
  @moduledoc """
  This is a plug that ensures workflows are present and loaded into assigns
  """

  import Plug.Conn
  alias Nenokit.{Surveys.Workflows, Roles}

  def init(options) do
    options
  end

  def call(conn, _options) do
    workflows = Workflows.list_workflows_by_user(conn.assigns.current_user.id)
    assign(conn, :workflows, workflows)
  end
end
