defmodule NenokitWeb.AdminPageController do
  use NenokitWeb, :controller

  alias Nenokit.{Pages, AuditTrails}

  def index(conn, _params) do
    pages = Pages.list_pages
    render(conn, "index.html", pages: pages)
  end

  def new(conn, _params) do
    changeset = Pages.change_page
    render(conn, "new.html", changeset: changeset, page: nil)
  end

  def create(conn, %{"page" => params}) do
    case Pages.create_page(params) do
      {:ok, page} ->
        # Log action in audit trial
        current_user = conn.assigns.current_user
        AuditTrails.create_audit_trail(current_user, %{"action" => "Created a new page", "module" => "admin_page", "record_id" => page.id})

        conn
        |> put_flash(:success, "Page created successfully")
        |> redirect(to: Routes.admin_page_path(conn, :show, page))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, page: nil)
    end
  end

  def show(conn, %{"id" => page_id}) do
    page = Pages.get_page(page_id)
    render(conn, "show.html", page: page)
  end

  def edit(conn, %{"id" => page_id}) do
    page = Pages.get_page(page_id)
    changeset = Pages.change_page(page)
    render(conn, "edit.html", page: page, changeset: changeset)
  end

  def update(conn, %{"id" => page_id, "page" => page_params}) do
    page = Pages.get_page(page_id)
    case Pages.update_page(page, page_params) do
      {:ok, page} ->
        # Log action in audit trial
        current_user = conn.assigns.current_user
        AuditTrails.create_audit_trail(current_user, %{"action" => "Updated a page", "module" => "admin_page", "record_id" => page.id})

        conn
        |> put_flash(:info, "Page updated successfully.")
        |> redirect(to: Routes.admin_page_path(conn, :show, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", page: page, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => page_id}) do
    page = Pages.get_page(page_id)
    {:ok, _page} = Pages.delete_page(page)

    # Log action in audit trial
    current_user = conn.assigns.current_user
    AuditTrails.create_audit_trail(current_user, %{"action" => "Deleted a page", "module" => "admin_page", "record_id" => page.id})

    conn
    |> put_flash(:info, "Page deleted successfully.")
    |> redirect(to: Routes.admin_page_path(conn, :index))
  end
end
