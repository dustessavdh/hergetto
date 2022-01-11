import Config

# Add default metadata for all the pages
config :hergetto, HergettoWeb.Meta, [
  %{name: "theme-color", content: "#6D28D9"},
  %{
    name: "keywords",
    content: "synchronized, together, youtube, videos, watch, friends, social, hergetto, funny"
  },
  %{
    name: "tags",
    content: "synchronized,together,youtube,videos,watch,friends,social,hergetto,funny"
  },
  %{
    name: "description",
    content:
      "Hergetto allows you to watch videos together with your friends. It's a fun and easy way to share videos with your friends!"
  },
  %{property: "og:type", content: "website"},
  %{property: "og:url", content: "https://hergetto.live/"},
  %{
    property: "og:description",
    content:
      "Hergetto allows you to watch videos together with your friends. It's a fun and easy way to share videos with your friends!"
  },
  %{property: "og:image", content: "assets/images/oembed_logo.png"},
  %{name: "twitter:card", content: "summary"},
  %{name: "twitter:url", content: "https://hergetto.live"},
  %{name: "twitter:image", content: "assets//images/oembed_logo.png"}
]
