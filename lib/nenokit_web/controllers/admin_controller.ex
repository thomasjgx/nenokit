defmodule NenokitWeb.AdminController do
    use NenokitWeb, :controller

    alias Nenokit.{Accounts, Pages.Blogs}

    def index(conn, _params) do
      # Get total number of users
      users = Accounts.get_user_count

      # Get total number of blogs
      blogs = Blogs.get_blog_count
      
      render(conn, "index.html", users: users, blogs: blogs)
    end

  end
  