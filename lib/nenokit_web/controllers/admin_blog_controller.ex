defmodule NenokitWeb.AdminBlogController do
  use NenokitWeb, :controller

  alias Nenokit.{Pages, Pages.Blogs, AuditTrails}

  def index(conn, _params) do
    blogs = Blogs.list_blogs
    render(conn, "index.html", blogs: blogs)
  end

  def new(conn, _params) do
    changeset = Blogs.change_blog
    pages = Pages.list_pages |> Enum.map(fn page -> {page.name, page.id} end)
    render(conn, "new.html", changeset: changeset, pages: pages, blog: nil)
  end

  def create(conn, %{"blog" => params}) do
    current_user = conn.assigns.current_user
    case Blogs.create_blog(current_user, params) do
      {:ok, blog} ->
        # Log action in audit trial
        AuditTrails.create_audit_trail(current_user, %{"action" => "Created a new blog", "module" => "admin_blog", "record_id" => blog.id})

        conn
        |> put_flash(:success, "Blog created successfully")
        |> redirect(to: Routes.admin_blog_path(conn, :show, blog))
      {:error, changeset} ->
        pages = Pages.list_pages |> Enum.map(fn page -> {page.name, page.id} end)
        render(conn, "new.html", changeset: changeset, pages: pages, blog: nil)
    end
  end

  def show(conn, %{"id" => blog_id}) do
    blog = Blogs.get_blog(blog_id)
    render(conn, "show.html", blog: blog)
  end

  def edit(conn, %{"id" => blog_id}) do
    blog = Blogs.get_blog(blog_id)
    changeset = Blogs.change_blog(blog)
    pages = Pages.list_pages |> Enum.map(fn page -> {page.name, page.id} end)
    render(conn, "edit.html", blog: blog, changeset: changeset, pages: pages)
  end

  def update(conn, %{"id" => blog_id, "blog" => blog_params}) do
    blog = Blogs.get_blog(blog_id)
    case Blogs.update_blog(blog, blog_params) do
      {:ok, blog} ->
        # Log action in audit trial
        current_user = conn.assigns.current_user
        AuditTrails.create_audit_trail(current_user, %{"action" => "Updated a blog", "module" => "admin_blog", "record_id" => blog.id})

        conn
        |> put_flash(:info, "Blog updated successfully.")
        |> redirect(to: Routes.admin_blog_path(conn, :show, blog))

      {:error, %Ecto.Changeset{} = changeset} ->
        pages = Pages.list_pages |> Enum.map(fn page -> {page.name, page.id} end)
        render(conn, "edit.html", blog: blog, changeset: changeset, pages: pages)
    end
  end

  def delete(conn, %{"id" => blog_id}) do
    blog = Blogs.get_blog(blog_id)
    {:ok, _blog} = Blogs.delete_blog(blog)

    # Log action in audit trial
    current_user = conn.assigns.current_user
    AuditTrails.create_audit_trail(current_user, %{"action" => "Deleted a blog", "module" => "admin_blog", "record_id" => blog.id})

    conn
    |> put_flash(:info, "Blog deleted successfully.")
    |> redirect(to: Routes.admin_blog_path(conn, :index))
  end
end
