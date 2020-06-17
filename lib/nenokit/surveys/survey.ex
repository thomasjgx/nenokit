defmodule Nenokit.Surveys.Survey do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Surveys.Survey.Schema

  schema "surveys" do
    field :name, :string
    field :description, :string
    embeds_one :schema, Schema

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
    |> cast_embed(:schema)
  end

end
