defmodule Nenokit.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Accounts.User

  schema "messages" do
    field :content, :string
    field :read, :boolean
    belongs_to :sender, User
    belongs_to :receiver, User

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:content, :sender_user_id, :receiver_user_id, :read])
    |> validate_required([:content, :sender_user_id, :receiver_user_id])
  end

end
