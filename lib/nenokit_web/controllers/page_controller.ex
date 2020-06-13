defmodule NenokitWeb.PageController do
  use NenokitWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def search(conn, _params) do
    render(conn, "search.html")
  end
end
