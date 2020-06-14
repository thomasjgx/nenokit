defmodule Nenokit.Roles do
  @moduledoc """
  Roles context to handle all roles, role_permissions and role_users data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias __MODULE__.{Role, RolePermission, RoleUser}

  def list_roles() do
    Repo.all(Role)
  end

  def change_role(role \\ %Role{}) do
    Role.changeset(role, %{})
  end

  def create_role(params) do
    result = %Role{}
    |> Role.changeset(params)
    |> Repo.insert

    case result do
      {:ok, role} = success ->
      
        # Add role permissions
        if !is_nil(params["permissions"]) do
          Enum.each(params["permissions"], fn permission ->
            %RolePermission{}
            |> RolePermission.changeset(%{"role_id" => role.id, "slug" => permission})
            |> Repo.insert
          end)
        end

        # Add role users
        if !is_nil(params["users"]) do
          Enum.each(params["users"], fn user ->
            %RoleUser{}
            |> RoleUser.changeset(%{"role_id" => role.id, "user_id" => user})
            |> Repo.insert
          end)
        end

        success
      {:error, _changeset} = error ->
        error
    end
  end

  def update_role(role, params) do
    result = role
    |> Role.changeset(params)
    |> Repo.update

    case result do
      {:ok, role} = success ->
        # Delete existing role permissions
        from(rp in RolePermission, where: rp.role_id == ^role.id) |> Repo.delete_all
        
        # Add role permissions
        if !is_nil(params["permissions"]) do
          Enum.each(params["permissions"], fn permission ->
            %RolePermission{}
            |> RolePermission.changeset(%{"role_id" => role.id, "slug" => permission})
            |> Repo.insert
          end)
        end

        # Delete existing role users
        from(ru in RoleUser, where: ru.role_id == ^role.id) |> Repo.delete_all
        
        # Add role users
        if !is_nil(params["users"]) do
          Enum.each(params["users"], fn user ->
            %RoleUser{}
            |> RoleUser.changeset(%{"role_id" => role.id, "user_id" => user})
            |> Repo.insert
          end)
        end

        success
      {:error, _changeset} = error ->
        error
    end
  end

  def get_role(id) do
    Repo.get(Role, id)
    |> Repo.preload([:role_users, :role_permissions])
  end

  def get_one() do
    Repo.one(Role)
  end

  def delete_role(role) do
    # Delete existing role permissions
    from(rp in RolePermission, where: rp.role_id == ^role.id) |> Repo.delete_all

    # Delete existing role users
    from(ru in RoleUser, where: ru.role_id == ^role.id) |> Repo.delete_all

    Repo.delete(role)
  end

  def add_role_user(role, user) do
    %RoleUser{}
    |> RoleUser.changeset(%{"role_id" => role.id, "user_id" => user.id})
    |> Repo.insert
  end

end
