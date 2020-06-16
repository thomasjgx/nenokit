defmodule NenokitWeb.PageController do
  use NenokitWeb, :controller

  alias Nenokit.{Pages, Pages.Blogs}

  def index(conn, _params) do
    page = Pages.get_first
    if page == nil do
      render(conn, "empty.html")
    else
      blogs = Blogs.list_blogs_by_page(page.id)
      page_menus = Pages.list_page_menus(page)
      render(conn, "index.html", page: page, blogs: blogs, page_menus: page_menus)
    end
  end

  def page(conn, %{"id" => id}) do
    page = Pages.get_page(id)
    blogs = Blogs.list_blogs_by_page(page.id)
    page_menus = Pages.list_page_menus(page)
    render(conn, "page.html", page: page, blogs: blogs, page_menus: page_menus)
  end

  def search(conn, _params) do
    render(conn, "search.html")
  end

  def terms_and_conditions(conn, _params) do
    settings = conn.assigns.settings
    render(conn, "terms_and_conditions.html", content: settings.configuration.terms_and_conditions)
  end

  def privacy_policy(conn, _params) do
    settings = conn.assigns.settings
    render(conn, "privacy_policy.html", content: settings.configuration.privacy_policy)
  end
end
