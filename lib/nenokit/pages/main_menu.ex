defmodule Nenokit.Pages.MainMenu do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Pages.Page

  schema "main_menu" do
    field :name, :string
    field :external_link, :string
    field :menu_index, :integer

    belongs_to :page, Page

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :external_link, :menu_index, :page_id])
    |> validate_required([:name, :menu_index])
  end

end
