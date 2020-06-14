# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Nenokit.Repo.insert!(%Nenokit.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Nenokit.Seed do
  alias Nenokit.Repo
  alias Nenokit.{Roles, Roles.Permission}

  @roles [
    %{
      "name" => "System Admin",
      "description" => "Can manage all the features of the system",
      "permissions" => Permission.get_permissions,
      "users" => []
    }
  ]

  def run(:test = env) do
    clean_all(env)
  end

  def run(:dev = env) do
    clean_all(env)

    seed_roles()
  end

  def run(:prod = env) do
    clean_all(env)

    seed_roles()
  end

  defp clean_all(_) do
    Repo.delete_all(Nenokit.Roles.Role)
  end

  defp seed_roles do
    Enum.each(@roles, fn role ->
      Roles.create_role(role)
    end)
  end
end

Nenokit.Seed.run(Mix.env())