defmodule NenokitWeb.Plugs.LoadWorkflows do
  @moduledoc """
  This is a plug that ensures workflows are present and loaded into assigns
  """

  import Plug.Conn
  alias Nenokit.Surveys.Workflows

  def init(options) do
    options
  end

  def call(conn, _options) do
    assign(conn, :workflows, Workflows.list_workflows)
  end
end
