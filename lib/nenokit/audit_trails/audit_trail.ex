defmodule Nenokit.AuditTrails.AuditTrail do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nenokit.Accounts.User

  @primary_key {:time, :naive_datetime, []}

  defimpl Phoenix.Param do
    def to_param(%{time: time}) do
      NaiveDateTime.to_iso8601(time)
    end
  end

  schema "audit_trails" do
    field :action, :string
    field :module, :string
    field :record_id, :integer
    belongs_to :user, User
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:action, :module, :record_id, :user_id, :time])
    |> validate_required([:action, :module, :user_id, :time])
  end

  defmodule Query do
    import Ecto.Query

    def latest(query \\ SensorValue, count) do
      from query, order_by: [desc: :time], limit: ^count
    end
  end

end
