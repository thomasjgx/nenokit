defmodule NenokitWeb.LayoutView do
  use NenokitWeb, :view

  def is_admin(current_user) do
    (Enum.count(current_user.roles) > 0)
  end

  def get_logo(settings) do
    image = Nenokit.SettingsFile.urls({settings.appearance.logo, settings})
    image.original
  end
end
