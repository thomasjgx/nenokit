defmodule NenokitWeb.LayoutView do
  use NenokitWeb, :view

  def is_admin(current_user) do
    (Enum.count(current_user.roles) > 0)
  end
end
