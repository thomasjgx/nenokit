defmodule NenokitWeb.AdminMainMenuController do
  use NenokitWeb, :controller

  alias Nenokit.{Pages, AuditTrails}
  alias NenokitWeb.Authentication

  def index(conn, _params) do
    main_menus = Pages.list_main_menus
    render(conn, "index.html", main_menus: main_menus)
  end

  def new(conn, _params) do
    changeset = Pages.change_main_menu
    pages = Pages.list_pages |> Enum.map(fn page -> {page.name, page.id} end)
    render(conn, "new.html", changeset: changeset, pages: pages)
  end

  def create(conn, %{"main_menu" => params}) do
    case Pages.create_main_menu(params) do
      {:ok, main_menu} ->
        # Log action in audit trial
        current_user = Authentication.get_current_user(conn)
        AuditTrails.create_audit_trail(current_user, %{"action" => "Created a new main menu", "module" => "admin_main_menu", "record_id" => main_menu.id})

        conn
        |> put_flash(:success, "Menu created successfully")
        |> redirect(to: Routes.admin_main_menu_path(conn, :index))
      {:error, changeset} ->
        pages = Pages.list_pages |> Enum.map(fn page -> {page.name, page.id} end)
        render(conn, "new.html", changeset: changeset, pages: pages)
    end
  end

  def edit(conn, %{"id" => menu_id}) do
    main_menu = Pages.get_main_menu(menu_id)
    changeset = Pages.change_main_menu(main_menu)
    pages = Pages.list_pages |> Enum.map(fn page -> {page.name, page.id} end)
    render(conn, "edit.html", main_menu: main_menu, changeset: changeset, pages: pages)
  end

  def update(conn, %{"id" => menu_id, "main_menu" => main_menu_params}) do
    main_menu = Pages.get_main_menu(menu_id)
    case Pages.update_main_menu(main_menu, main_menu_params) do
      {:ok, main_menu} ->
        # Log action in audit trial
        current_user = Authentication.get_current_user(conn)
        AuditTrails.create_audit_trail(current_user, %{"action" => "Updated a main menu", "module" => "admin_main_menu", "record_id" => main_menu.id})

        conn
        |> put_flash(:info, "Main menu updated successfully.")
        |> redirect(to: Routes.admin_main_menu_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        pages = Pages.list_pages |> Enum.map(fn page -> {page.name, page.id} end)
        render(conn, "edit.html", main_menu: main_menu, changeset: changeset, pages: pages)
    end
  end

  def delete(conn, %{"id" => menu_id}) do
    main_menu = Pages.get_main_menu(menu_id)
    {:ok, _main_menu} = Pages.delete_main_menu(main_menu)

    # Log action in audit trial
    current_user = Authentication.get_current_user(conn)
    AuditTrails.create_audit_trail(current_user, %{"action" => "Deleted a main menu", "module" => "admin_main_menu", "record_id" => main_menu.id})

    conn
    |> put_flash(:info, "Main menu deleted successfully.")
    |> redirect(to: Routes.admin_main_menu_path(conn, :index))
  end
end
