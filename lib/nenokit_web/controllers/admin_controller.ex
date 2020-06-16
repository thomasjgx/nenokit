defmodule NenokitWeb.AdminController do
    use NenokitWeb, :controller

    alias Nenokit.{Accounts, Pages.Blogs, AuditTrails}

    def index(conn, _params) do
      # Get total number of users
      users = Accounts.get_user_count

      # Get total number of blogs
      blogs = Blogs.get_blog_count

      # Get latest audit trails
      audit_trails = AuditTrails.list_audit_trails
      
      render(conn, "index.html", users: users, blogs: blogs, audit_trails: audit_trails)
    end

  end
  