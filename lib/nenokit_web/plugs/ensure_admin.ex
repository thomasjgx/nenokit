defmodule NenokitWeb.Plugs.EnsureAdmin do
  @moduledoc """
  This is plug that ensures the logged in user has a particular tole
  """
  use NenokitWeb, :controller
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _options) do
    current_user = conn.assigns.current_user

    current_user
    |> has_role?()
    |> maybe_halt(conn)
    |> load_user_and_permissions(current_user)
  end

  defp has_role?(nil), do: false
  defp has_role?(user), do: (Enum.count(user.roles) > 0)

  def maybe_halt(true, conn), do: conn
  def maybe_halt(false, conn) do
    conn
    |> redirect(to: Routes.page_path(conn, :unauthorized))
    |> halt()
  end

  def load_user_and_permissions(conn, user) do
    permissions = Enum.reduce(user.roles, [], fn role, accm ->
      permission_slugs = Enum.map(role.role_permissions, fn role_permission ->
        role_permission.slug
      end)
      accm ++ permission_slugs
    end)
    
    conn
    |> assign(:current_user, user)
    |> assign(:permissions, permissions)
  end
end
