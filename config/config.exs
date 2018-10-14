# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :bai,
  ecto_repos: [Bai.Repo]

# Configures the endpoint
config :bai, BaiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/7MWXFHcU1kIxqy3tpGuFUlAFBCVGVouHJ7jSwWWpbfxPkodbmlacH6curM4t9BW",
  render_errors: [view: BaiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bai.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
