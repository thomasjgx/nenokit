defmodule Nenokit.Medias do
  @moduledoc """
  Media context to handle all media data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias __MODULE__.Media

  def list_media() do
    Repo.all(from m in Media, select: m, order_by: [asc: :id])
  end

  def change_media(media \\ %Media{}) do
    Media.changeset(media, %{})
  end

  def create_media(params) do
    %Media{}
    |> Media.changeset(params)
    |> Repo.insert
  end

  def update_media(media, params) do
    media
    |> Media.changeset(params)
    |> Repo.update
  end

  def get_media(id) do
    Repo.get(Media, id)
  end

  def delete_media(media) do
    Repo.delete(media)
  end
end
