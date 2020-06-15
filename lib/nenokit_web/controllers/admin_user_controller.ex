defmodule NenokitWeb.AdminUserController do
  use NenokitWeb, :controller

  alias Nenokit.{Accounts, AuditTrails}

  def index(conn, _) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => user_id}) do
    user = Accounts.get_user!(user_id)
    audit_trails = AuditTrails.list_audit_trails_by_user(user)
    render(conn, "show.html", user: user, audit_trails: audit_trails)
  end

  def edit(conn, %{"id" => user_id}) do
    user = Accounts.get_user!(user_id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => user_id, "user" => user_params}) do
    user = Accounts.get_user!(user_id)
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        # Log action in audit trial
        current_user = conn.assigns.current_user
        AuditTrails.create_audit_trail(current_user, %{"action" => "Updated a user", "module" => "admin_user", "record_id" => user.id})

        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.admin_user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => user_id}) do
    user = Accounts.get_user!(user_id)
    {:ok, _user} = Accounts.delete_user(user)

    # Log action in audit trial
    current_user = conn.assigns.current_user
    AuditTrails.create_audit_trail(current_user, %{"action" => "Deleted a user", "module" => "admin_user", "record_id" => user.id})

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.admin_user_path(conn, :index))
  end
end
