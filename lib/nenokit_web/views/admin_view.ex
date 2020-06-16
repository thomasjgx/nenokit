defmodule NenokitWeb.AdminView do
  use NenokitWeb, :view

  def get_days_ago(date) do
    case date |> Timex.format("{relative}", :relative) do
      {:ok, relative_time} ->
        relative_time
      _ ->
        date
    end
  end

  def get_route_from_audit(conn, "admin_user", record_id) do
    Routes.admin_user_path(conn, :show, record_id)
  end

  def get_route_from_audit(conn, "admin_page", record_id) do
    Routes.admin_page_path(conn, :show, record_id)
  end 

  def get_route_from_audit(conn, "admin_main_menu", record_id) do
    Routes.admin_main_menu_path(conn, :edit, record_id)
  end 

  def get_route_from_audit(conn, "admin_blog", record_id) do
    Routes.admin_blog_path(conn, :show, record_id)
  end 

  def get_route_from_audit(conn, "admin_role", record_id) do
    Routes.admin_role_path(conn, :edit, record_id)
  end 

  def get_route_from_audit(_conn, _, _) do
    "#"
  end 
end