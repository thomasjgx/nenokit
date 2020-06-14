defmodule NenokitWeb.Plugs.LoadSettings do
  @moduledoc """
  This is a plug that ensures settings are present and loaded into assigns, if not it will
  redirect the user to the setup page.
  """

  import Plug.Conn
  import Phoenix.Controller

  alias NenokitWeb.Router.Helpers, as: Routes

  alias Nenokit.Settings

  def init(options) do
    options
  end

  def call(conn, _options) do
    case Settings.get_settings do
      nil ->
        # Redirect to the setup page
        conn
        |> redirect(to: Routes.setup_path(conn, :index))
        |> halt()
      settings ->
        # Add settings to the conn
        assign(conn, :settings, settings)
    end
  end
end
