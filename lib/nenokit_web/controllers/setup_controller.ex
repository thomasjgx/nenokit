defmodule NenokitWeb.SetupController do
  use NenokitWeb, :controller
  alias Nenokit.Settings

  plug :put_layout, "session.html"

  def index(conn, _params) do
    changeset = Settings.change_settings
    render(conn, "settings.html", changeset: changeset)
  end

  def create(conn, %{"setting" => params}) do
    case Settings.create_settings(params) do
      {:ok, _settings} ->
        conn
        |> redirect(to: Routes.user_registration_path(conn, :new))
      {:error, changeset} ->
        render(conn, "settings.html", changeset: changeset)
    end
  end
end
