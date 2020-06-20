# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nenokit,
  ecto_repos: [Nenokit.Repo]

# Configures the endpoint
config :nenokit, NenokitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "r2cYYLD4TeESQU/9l9FwZIPGtGbqo5cZdEpTYAFkFVJWHffiOlI8E+cg1YgAfZSS",
  render_errors: [view: NenokitWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Nenokit.PubSub,
  live_view: [signing_salt: "B03ScHtj"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Arc File Upload
config :arc,
  storage: Arc.Storage.Local

# SMS
config :nenokit, Nenokit.SMS, adapter: SMS.LogAdapter

# HTTPClient
config :nenokit, Nenokit.HTTPClient,
  adapter: HTTPoison,
  adapter_options: [
    recv_timeout: 30_000
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
