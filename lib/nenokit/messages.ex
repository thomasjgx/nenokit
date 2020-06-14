defmodule Nenokit.Messages do
  @moduledoc """
  Messages context to handle all messages data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias Nenokit.Messages.Message

  def list_messages_by_user(user) do
    Repo.all(from m in Message, select: m, where: m.user_id == ^user.id, order_by: [desc: :inserted_at])
  end

  def create_message(user, params) do
    params_with_user_id = params |> Map.put("user_id", user.id)
    %Message{}
    |> Message.changeset(params_with_user_id)
    |> Repo.insert
  end

  def mark_message_as_read(message) do
    message
    |> Message.changeset(%{"read" => true})
    |> Repo.update
  end

  def get_unread_messages_count(user) do
    Repo.one(from m in Message, select: count(m.id), where: m.user_id == ^user.id and m.read == false)
  end
end