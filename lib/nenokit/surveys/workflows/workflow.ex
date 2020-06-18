defmodule Nenokit.Surveys.Workflow do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Surveys.Workflow.Settings

  schema "workflows" do
    field :name, :string
    field :description, :string
    embeds_one :settings, Settings

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
    |> cast_embed(:settings)
  end

end
