# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :swagger_poc,
  ecto_repos: [SwaggerPoc.Repo]

# Configures the endpoint
config :swagger_poc, SwaggerPoc.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2S3KYuhSdaVdRpuY7B97gQ47MzuzWJmOy4/bF6J5ixpP8ltiEiEo7nhyPvXvMI2q",
  render_errors: [view: SwaggerPoc.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SwaggerPoc.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
