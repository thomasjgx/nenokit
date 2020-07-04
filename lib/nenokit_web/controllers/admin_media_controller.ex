defmodule NenokitWeb.AdminMediaController do
  use NenokitWeb, :controller

  alias Nenokit.{Medias, AuditTrails}

  def index(conn, _params) do
    medias = Medias.list_media
    render(conn, "index.html", medias: medias)
  end

  def new(conn, _params) do
    changeset = Medias.change_media
    render(conn, "new.html", changeset: changeset, page: nil)
  end

  def create(conn, %{"media" => params}) do
    case Medias.create_media(params) do
      {:ok, media} ->
        # Log action in audit trial
        current_user = conn.assigns.current_user
        AuditTrails.create_audit_trail(current_user, %{"action" => "Created a new media", "module" => "admin_media", "record_id" => media.id})

        conn
        |> put_flash(:success, "Media created successfully")
        |> redirect(to: Routes.admin_media_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, media: nil)
    end
  end

  def edit(conn, %{"id" => media_id}) do
    media = Medias.get_media(media_id)
    changeset = Medias.change_media(media)
    render(conn, "edit.html", media: media, changeset: changeset)
  end

  def update(conn, %{"id" => media_id, "media" => media_params}) do
    media = Medias.get_media(media_id)
    case Medias.update_media(media, media_params) do
      {:ok, media} ->
        # Log action in audit trial
        current_user = conn.assigns.current_user
        AuditTrails.create_audit_trail(current_user, %{"action" => "Updated a media", "module" => "admin_media", "record_id" => media.id})

        conn
        |> put_flash(:info, "Media updated successfully.")
        |> redirect(to: Routes.admin_media_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", media: media, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => media_id}) do
    media = Medias.get_media(media_id)
    {:ok, _media} = Medias.delete_media(media)

    # Log action in audit trial
    current_user = conn.assigns.current_user
    AuditTrails.create_audit_trail(current_user, %{"action" => "Deleted a media", "module" => "admin_page", "record_id" => media.id})

    conn
    |> put_flash(:info, "Media deleted successfully.")
    |> redirect(to: Routes.admin_media_path(conn, :index))
  end
end
