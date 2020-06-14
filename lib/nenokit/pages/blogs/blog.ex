defmodule Nenokit.Pages.Blogs.Blog do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.{Pages.Page, Accounts.User}

  schema "blogs" do
    field :name, :string
    field :content, :string
    belongs_to :page, Page
    belongs_to :author, User, foreign_key: :author_user_id

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :content, :page_id, :author_user_id])
    |> validate_required([:name, :content, :page_id, :author_user_id])
  end

end
