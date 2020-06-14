defmodule Nenokit.Notifications.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Accounts.User

  schema "notifications" do
    field :content, :string
    field :module, :string
    field :record_id, :integer
    field :read, :boolean
    belongs_to :user, User

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:content, :module, :record_id, :read, :user_id])
    |> validate_required([:content, :module, :user_id])
  end

end
