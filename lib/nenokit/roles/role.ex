defmodule Nenokit.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Roles.{RolePermission, RoleUser, RoleWorkflow}

  schema "roles" do
    field :name, :string
    field :description, :string

    has_many :role_users, RoleUser
    has_many :role_workflows, RoleWorkflow
    has_many :role_permissions, RolePermission

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :uidx_roles_name, message: "has already been taken")
  end
end