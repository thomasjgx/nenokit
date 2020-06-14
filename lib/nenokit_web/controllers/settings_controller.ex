defmodule NenokitWeb.SettingsController do
    use NenokitWeb, :controller
  
    alias Nenokit.{Settings, Settings.Setting}
  
    def edit(conn, _params) do
      settings = Settings.get_settings
      changeset = Setting.changeset(settings, %{})
      render(conn, "edit.html", settings: settings, changeset: changeset)
    end
  
    def update(conn, %{"setting" => params}) do
      settings = Settings.get_settings
      changeset =
        case Settings.update_settings(settings, params) do
          {:ok, settings} ->
            conn |> put_flash(:success, "Settings updated successfully")
            Setting.changeset(settings, %{})
          {:error, changeset} ->
            changeset
        end
      render(conn, "edit.html", settings: settings, changeset: changeset)
    end
  end