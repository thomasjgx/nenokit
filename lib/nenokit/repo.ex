defmodule Nenokit.Repo do
  use Ecto.Repo,
    otp_app: :nenokit,
    adapter: Ecto.Adapters.Postgres
end
