defmodule NenokitWeb.AdminMediaView do
  use NenokitWeb, :view

  def get_file(media) do
    image = Nenokit.MediaFile.urls({media.file, media})
    image.original
  end
end
