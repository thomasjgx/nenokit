defmodule Nenokit.Pages.Blogs do
  @moduledoc """
  Blogs context to handle all blogs data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias __MODULE__.Blog

  def list_blogs() do
    Repo.all(Blog)
  end

  def search_blogs(search) do
    Repo.all(from b in Blog, select: b, where: ilike(b.name, ^"%#{search}%"), order_by: [desc: :inserted_at])
    |> Repo.preload(:author)
  end

  def list_blogs_by_page(page_id) do
    Repo.all(from b in Blog, select: b, where: b.page_id == ^page_id, order_by: [desc: :inserted_at])
    |> Repo.preload(:author)
  end

  def change_blog(blog \\ %Blog{}) do
    Blog.changeset(blog, %{})
  end

  def create_blog(user, params) do
    params_with_user_id = params |> Map.put("author_user_id", user.id)
    %Blog{}
    |> Blog.changeset(params_with_user_id)
    |> Repo.insert
  end

  def update_blog(blog, params) do
    blog
    |> Blog.changeset(params)
    |> Repo.update
  end

  def get_blog(id) do
    Repo.get(Blog, id)
    |> Repo.preload(:author)
  end

  def get_blog_count() do
    Repo.one(from b in Blog, select: count(b.id))
  end

  def delete_blog(blog) do
    Repo.delete(blog)
  end
end
