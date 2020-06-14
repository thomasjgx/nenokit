defmodule NenokitWeb.AdminPageMenuController do
  use NenokitWeb, :controller

  alias Nenokit.{Pages, AuditTrails}
  alias NenokitWeb.Authentication

  def index(conn, %{"parent_page_id" => parent_page_id}) do
    parent_page = Pages.get_page(parent_page_id)
    page_menus = Pages.list_page_menus(parent_page)
    render(conn, "index.html", page_menus: page_menus, parent_page: parent_page)
  end

  def new(conn, %{"parent_page_id" => parent_page_id}) do
    parent_page = Pages.get_page(parent_page_id)
    changeset = Pages.change_page_menu
    pages = Pages.list_pages |> Enum.map(fn page -> {page.name, page.id} end)
    render(conn, "new.html", changeset: changeset, parent_page: parent_page, pages: pages)
  end

  def create(conn, %{"parent_page_id" => parent_page_id, "page_menu" => params}) do
    parent_page = Pages.get_page(parent_page_id)
    case Pages.create_page_menu(parent_page, params) do
      {:ok, page_menu} ->
        # Log action in audit trial
        current_user = Authentication.get_current_user(conn)
        AuditTrails.create_audit_trail(current_user, %{"action" => "Created a new page menu", "module" => "admin_page_menu", "record_id" => page_menu.id})

        conn
        |> put_flash(:success, "Menu created successfully")
        |> redirect(to: Routes.admin_page_menu_path(conn, :index, parent_page))
      {:error, changeset} ->
        pages = Pages.list_pages |> Enum.map(fn page -> {page.name, page.id} end)
        render(conn, "new.html", changeset: changeset, parent_page: parent_page, pages: pages)
    end
  end

  def edit(conn, %{"parent_page_id" => parent_page_id, "id" => menu_id}) do
    parent_page = Pages.get_page(parent_page_id)
    page_menu = Pages.get_page_menu(menu_id)
    changeset = Pages.change_page_menu(page_menu)
    pages = Pages.list_pages |> Enum.map(fn page -> {page.name, page.id} end)
    render(conn, "edit.html", page_menu: page_menu, changeset: changeset, parent_page: parent_page, pages: pages)
  end

  def update(conn, %{"parent_page_id" => parent_page_id, "id" => menu_id, "page_menu" => page_menu_params}) do
    parent_page = Pages.get_page(parent_page_id)
    page_menu = Pages.get_main_menu(menu_id)
    case Pages.update_page(page_menu, page_menu_params) do
      {:ok, page_menu} ->
        # Log action in audit trial
        current_user = Authentication.get_current_user(conn)
        AuditTrails.create_audit_trail(current_user, %{"action" => "Updated a page menu", "module" => "admin_page_menu", "record_id" => page_menu.id})

        conn
        |> put_flash(:info, "Page menu updated successfully.")
        |> redirect(to: Routes.admin_page_menu_path(conn, :index, parent_page))

      {:error, %Ecto.Changeset{} = changeset} ->
        pages = Pages.list_pages |> Enum.map(fn page -> {page.name, page.id} end)
        render(conn, "edit.html", page_menu: page_menu, changeset: changeset, parent_page: parent_page, pages: pages)
    end
  end

  def delete(conn, %{"parent_page_id" => parent_page_id, "id" => menu_id}) do
    parent_page = Pages.get_page(parent_page_id)
    page_menu = Pages.get_page_menu(menu_id)
    {:ok, _page_menu} = Pages.delete_page_menu(page_menu)

    # Log action in audit trial
    current_user = Authentication.get_current_user(conn)
    AuditTrails.create_audit_trail(current_user, %{"action" => "Deleted a page menu", "module" => "admin_page_menu", "record_id" => page_menu.id})
    
    conn
    |> put_flash(:info, "Page menu deleted successfully.")
    |> redirect(to: Routes.admin_page_menu_path(conn, :index, parent_page))
  end
end
