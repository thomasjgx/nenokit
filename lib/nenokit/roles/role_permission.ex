defmodule Nenokit.Roles.RolePermission do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Roles.Role

  schema "role_permissions" do
    field :slug, :string
    belongs_to :role, Role

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:role_id, :slug])
    |> validate_required([:role_id, :slug])
    |> unique_constraint(:role_permissions, name: :uidx_role_id_slug, message: "has already been taken")
  end
end