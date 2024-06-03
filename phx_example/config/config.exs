# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :phx_example,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :phx_example, PhxExampleWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PhxExampleWeb.ErrorHTML, json: PhxExampleWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PhxExample.PubSub,
  live_view: [signing_salt: "uCRlxId+"]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  phx_example: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
