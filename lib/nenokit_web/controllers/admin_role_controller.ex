defmodule NenokitWeb.AdminRoleController do
  use NenokitWeb, :controller

  alias Nenokit.{Roles, Roles.Permission, Accounts, AuditTrails}

  def index(conn, _params) do
    roles = Roles.list_roles
    render(conn, "index.html", roles: roles)
  end

  def new(conn, _params) do
    changeset = Roles.change_role
    selected_users = []
    selected_permissions = []
    users = Accounts.list_users |> Enum.map(fn user -> {user.name, user.id} end)
    permissions = Permission.get_permissions
    render(conn, "new.html", changeset: changeset, selected_users: selected_users, selected_permissions: selected_permissions, users: users, permissions: permissions)
  end

  def create(conn, %{"role" => params}) do
    case Roles.create_role(params) do
      {:ok, role} ->
        # Log action in audit trial
        current_user = conn.assigns.current_user
        AuditTrails.create_audit_trail(current_user, %{"action" => "Created a new role", "module" => "admin_role", "record_id" => role.id})

        conn
        |> put_flash(:success, "Role created successfully")
        |> redirect(to: Routes.admin_role_path(conn, :index))
      {:error, changeset} ->
        selected_users = []
        selected_permissions = []
        users = Accounts.list_users |> Enum.map(fn user -> {user.name, user.id} end)
        permissions = Permission.get_permissions
        render(conn, "new.html", changeset: changeset, selected_users: selected_users, selected_permissions: selected_permissions, users: users, permissions: permissions)
    end
  end

  def edit(conn, %{"id" => role_id}) do
    role = Roles.get_role(role_id)
    changeset = Roles.change_role(role)
    selected_users = role.role_users |> Enum.map(fn role_user -> role_user.user_id  end)
    selected_permissions = role.role_permissions |> Enum.map(fn role_permission -> role_permission.slug end)
    users = Accounts.list_users |> Enum.map(fn user -> {user.name, user.id} end)
    permissions = Permission.get_permissions
    render(conn, "edit.html", role: role, changeset: changeset, selected_users: selected_users, selected_permissions: selected_permissions, users: users, permissions: permissions)
  end

  def update(conn, %{"id" => role_id, "role" => role_params}) do
    role = Roles.get_role(role_id)
    case Roles.update_role(role, role_params) do
      {:ok, role} ->
        # Log action in audit trial
        current_user = conn.assigns.current_user
        AuditTrails.create_audit_trail(current_user, %{"action" => "Updated a role", "module" => "admin_role", "record_id" => role.id})

        conn
        |> put_flash(:info, "Role updated successfully.")
        |> redirect(to: Routes.admin_role_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        selected_users = role.role_users |> Enum.map(fn role_user -> role_user.user_id  end)
        selected_permissions = role.role_permissions |> Enum.map(fn role_permission -> role_permission.slug end)
        users = Accounts.list_users |> Enum.map(fn user -> {user.name, user.id} end)
        permissions = Permission.get_permissions
        render(conn, "edit.html", role: role, changeset: changeset, selected_users: selected_users, selected_permissions: selected_permissions, users: users, permissions: permissions)
    end
  end

  def delete(conn, %{"id" => role_id}) do
    role = Roles.get_role(role_id)
    {:ok, _role} = Roles.delete_role(role)

    # Log action in audit trial
    current_user = conn.assigns.current_user
    AuditTrails.create_audit_trail(current_user, %{"action" => "Deleted a role", "module" => "admin_role", "record_id" => role.id})

    conn
    |> put_flash(:info, "Role deleted successfully.")
    |> redirect(to: Routes.admin_role_path(conn, :index))
  end
end
