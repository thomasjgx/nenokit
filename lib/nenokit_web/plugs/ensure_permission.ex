defmodule NenokitWeb.Plug.EnsurePermission do
  @moduledoc """
  This is plug that ensures the logged in user has a particular tole
  """
  use NenokitWeb, :controller
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, permission) do
    conn.assigns.permissions
    |> has_permission?(permission)
    |> maybe_halt(conn)
  end

  defp has_permission?(permissions, permission), do: Enum.member?(permissions, permission)

  def maybe_halt(true, conn), do: conn
  def maybe_halt(false, conn) do
    conn
    |> redirect(to: Routes.page_path(conn, :unauthorized))
    |> halt()
  end
end
