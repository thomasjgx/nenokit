defmodule Nenokit.Pages.PageMenu do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Pages.Page

  schema "page_menus" do
    field :name, :string
    field :external_link, :string
    field :menu_index, :integer

    belongs_to :parent_page, Page
    belongs_to :page, Page

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :external_link, :menu_index, :parent_page_id, :page_id])
    |> validate_required([:name, :menu_index, :parent_page_id])
  end

end
