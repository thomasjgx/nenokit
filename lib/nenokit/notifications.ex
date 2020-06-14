defmodule Nenokit.Notifications do
  @moduledoc """
  Notifications context to handle all notifications data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias Nenokit.Notifications.Notification

  def list_notifications_by_user(user) do
    Repo.all(from n in Notification, select: n, where: n.user_id == ^user.id, order_by: [desc: :inserted_at])
  end

  def create_notification(user, params) do
    params_with_user_id = params |> Map.put("user_id", user.id)
    %Notification{}
    |> Notification.changeset(params_with_user_id)
    |> Repo.insert
  end

  def mark_notification_as_read(notification) do
    notification
    |> Notification.changeset(%{"read" => true})
    |> Repo.update
  end

  def get_unread_notifications_count(user) do
    Repo.one(from n in Notification, select: count(n.id), where: n.user_id == ^user.id and n.read == false)
  end

end