# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config
require Logger

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

config :surface, :components, [
  {Surface.Components.Form.ErrorTag, default_translator: {HergettoWeb.ErrorHelpers, :translate_error}}
]

# default cronjobs to run
config :hergetto, Hergetto.Scheduler,
  jobs: [
    greetings: [
      schedule: "@reboot",
      task: {Hergetto.Scheduler.Greetings, :greetings, []}
    ]
  ]

# Add default metadata for all the pages
config :hergetto, HergettoWeb.Meta, [
  %{name: "title", content: "Hergetto · Together in a safe way!"},
  %{name: "keywords", content: "phoenix watch youtube videos together hergetto"},
  %{name: "tags", content: "phoenix,watch,youtube,videos,together,hergetto"},
  %{
    name: "description",
    content:
      "Wanna watch videos together on a couch, but online? You can do that here! Find or create a room, send the link to your friends and start watching together. Hergetto stands for Together."
  },
  %{property: "og:type", content: "website"},
  %{property: "og:url", content: "https://hergetto.live/"},
  %{property: "og:title", content: "Hergetto · Together in a safe way!"},
  %{
    property: "og:description",
    content:
      "Wanna watch videos together on a couch, but online? You can do that here! Find or create a room, send the link to your friends and start watching together. Hergetto stands for Together."
  },
  %{property: "og:image", content: "/images/oembed_logo.png"},
  %{name: "twitter:card", content: "summary"},
  %{name: "twitter:url", content: "https://hergetto.live"},
  %{name: "twitter:title", content: "Hergetto · Together in a safe way!"},
  %{name: "twitter:image", content: "/images/oembed_logo.png"}
]

config :ueberauth, Ueberauth,
  providers: [google: {Ueberauth.Strategy.Google, []}
]

if config_env() == :prod || config_env() == :dev do
  try do
    import_config "ueberauth.secret.exs"
  rescue
    _ ->
      Logger.error("Please create a ueberauth.secret.exs")
  end
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
