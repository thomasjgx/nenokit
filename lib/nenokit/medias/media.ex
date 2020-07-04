defmodule Nenokit.Medias.Media do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.MediaFile

  schema "media" do
    field :name, :string
    field :file, MediaFile.Type

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> cast_attachments(params, [:file])
  end

end
