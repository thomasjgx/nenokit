defmodule Nenokit.AuditTrails do
  @moduledoc """
  AuditTrail context to handle all audit_trails data manipulation
  """
  import Ecto.Query, only: [from: 2]

  alias Nenokit.Repo
  alias Nenokit.AuditTrails.AuditTrail

  def list_audit_trails_by_user(user) do
    Repo.all(from a in AuditTrail, select: a, where: a.user_id == ^user.id, order_by: [desc: :time], limit: 10)
  end

  def create_audit_trail(user, params) do
    params_with_user_id_and_time = params |> Map.put("user_id", user.id) |> Map.put("time", NaiveDateTime.utc_now())
    %AuditTrail{}
    |> AuditTrail.changeset(params_with_user_id_and_time)
    |> Repo.insert
  end
end