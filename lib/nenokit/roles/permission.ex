defmodule Nenokit.Roles.Permission do
  @moduledoc """
  Permissions module to get all the permissions
  """

  def get_permissions do
    [
      "manage_pages",
      "manage_blogs",
      "manage_users",
      "manage_roles",
      "manage_settings",
      "manage_areas",
      "manage_campaigns"
    ]
  end
end