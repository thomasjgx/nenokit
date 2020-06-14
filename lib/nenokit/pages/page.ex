defmodule Nenokit.Pages.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field :name, :string
    field :layout, :string
    field :content, :string

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :layout, :content])
    |> validate_required([:name, :layout, :content])
  end

end
