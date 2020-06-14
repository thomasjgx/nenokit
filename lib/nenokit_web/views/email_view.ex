defmodule NenokitWeb.EmailView do
  use NenokitWeb, :view

  alias Nenokit.Settings

  def get_settings() do
    Settings.get_settings()
  end
end
