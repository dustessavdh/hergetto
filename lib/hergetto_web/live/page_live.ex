defmodule HergettoWeb.PageLive do
  use HergettoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    meta_attrs = [
      %{name: "title", content: "Hergetto · Together in a safe way!"},
      %{name: "keywords", content: "phoenix watch youtube videos together hergetto"},
      %{name: "tags", content: "phoenix,watch,youtube,videos,together,hergetto"},
      %{name: "description", content: "Wanna watch videos together on a couch, but online? You can do that here! Find or create a room, send the link to your friends and start watching together. Hergetto stands for Together."},
      %{property: "og:type", content: "website"},
      %{property: "og:url", content: "https://hergetto.live/"},
      %{property: "og:title", content: "Hergetto · Together in a safe way!"},
      %{property: "og:description", content: "Wanna watch videos together on a couch, but online? You can do that here! Find or create a room, send the link to your friends and start watching together. Hergetto stands for Together."},
      %{property: "og:image", content: Routes.static_path(socket, "/images/oembed_logo.png")},
      %{name: "twitter:card", content: "summary"},
      %{name: "twitter:url", content: "https://hergetto.live"},
      %{name: "twitter:title", content: "Hergetto · Together in a safe way!"},
      %{name: "twitter:image", content: Routes.static_path(socket, "/images/oembed_logo.png")}
    ]

    {:ok, assign(socket, query: "", results: %{}, meta_attrs: meta_attrs)}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not HergettoWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end
