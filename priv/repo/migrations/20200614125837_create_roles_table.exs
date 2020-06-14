defmodule Nenokit.Repo.Migrations.CreateRolesTable do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false
      add :description, :string

      timestamps()
    end

    create unique_index(:roles, ["lower(name)"], name: "uidx_roles_name")

    create table(:role_permissions) do
      add(:role_id, references(:roles), null: false)
      add :slug, :string

      timestamps()
    end

    create(
      unique_index(
        :role_permissions,
        [:role_id, :slug],
        name: "uidx_role_id_slug"
      )
    )

    create table(:role_users) do
      add(:role_id, references(:roles), null: false)
      add(:user_id, references(:users), null: false)

      timestamps()
    end

    create(
      unique_index(
        :role_users,
        [:role_id, :user_id],
        name: "uidx_role_id_user_id"
      )
    )
  end
end
