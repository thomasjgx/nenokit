defmodule Nenokit.Settings.Setting do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Settings.{Configuration, Appearance}

  schema "settings" do
    embeds_one :configuration, Configuration
    embeds_one :appearance, Appearance

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = settings, attrs) do
    settings
    |> cast(attrs, [])
    |> cast_embed(:configuration)
    |> cast_embed(:appearance)
  end
end
