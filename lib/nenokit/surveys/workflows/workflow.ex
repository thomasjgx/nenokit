defmodule Nenokit.Surveys.Workflow do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workflows" do
    field :name, :string
    field :description, :string
    field :settings, :map

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :description, :settings])
    |> validate_required([:name, :description])
  end

end
