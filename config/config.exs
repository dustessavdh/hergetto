# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config
import Logger

config :hergetto,
  ecto_repos: [Hergetto.Repo]

# Configures the endpoint
config :hergetto, HergettoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jo7BOHYvB7IEnLh3KI/ecNke+u04Icppyk60UK/QhhAKBCAJH8uZzPaqlsfOgKZN",
  render_errors: [view: HergettoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Hergetto.PubSub,
  live_view: [signing_salt: "0Hirw91y"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :filter_parameters, [
  "external_id",
  "username",
  "profile_picture",
  "email"
]

config :surface, :components, [
  {
    Surface.Components.Form.ErrorTag,
    default_translator: {HergettoWeb.ErrorHelpers, :translate_error}
  }
]

# default cronjobs to run
config :hergetto, Hergetto.Scheduler,
  jobs: [
    greetings: [
      schedule: "@reboot",
      task: {Hergetto.Scheduler.Greetings, :greetings, []}
    ]
  ]

config :ueberauth, Ueberauth,
  providers: [
    google: {
      Ueberauth.Strategy.Google,
      [
        default_scope: "email profile"
      ]
    }
  ]

if config_env() == :prod || config_env() == :dev do
  try do
    import_config "config.secret.exs"
  rescue
    _ ->
      Logger.error("Please create a config.secret.exs")
  end
end

try do
  import_config "meta_tags.exs"
rescue
  _ ->
    raise "Could not import meta_tags.exs"
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
