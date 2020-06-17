defmodule Nenokit.Settings.Appearance do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset
  alias Nenokit.SettingsFile

  embedded_schema do
    field :logo, SettingsFile.Type
  end

  @doc false
  def changeset(%__MODULE__{} = appearance, attrs) do
    appearance
    |> cast(attrs, [])
    |> cast_attachments(attrs, [:logo])
  end
end
