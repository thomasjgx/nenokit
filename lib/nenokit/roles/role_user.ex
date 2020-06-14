defmodule Nenokit.Roles.RoleUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Roles.Role
  alias Nenokit.Accounts.User

  schema "role_users" do
    belongs_to :role, Role
    belongs_to :user, User

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:role_id, :user_id])
    |> validate_required([:role_id, :user_id])
    |> unique_constraint(:role_users, name: :uidx_role_id_user_id, message: "has already been taken")
  end
end
