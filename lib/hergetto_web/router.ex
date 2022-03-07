defmodule HergettoWeb.Router do
  use HergettoWeb, :router
  import Surface.Catalogue.Router
  import HergettoWeb.Plugs.ContentSecurityPolicy

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HergettoWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_content_security_policy_headers
    plug Hergetto.Authentication.Pipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_authenticated_user do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :redirect_if_user_is_authenticated do
    plug Guardian.Plug.EnsureNotAuthenticated
  end

  # Maybe logged in routes
  scope "/", HergettoWeb do
    pipe_through [:browser]

    live "/", PageLive
  end

  scope "/rooms", HergettoWeb do
    pipe_through [:browser]

    live "/", RoomsLive

    get "/new", RoomsController, :new
    live "/:room_id", WatchLive
  end

  scope "/", HergettoWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/account", AccountLive
  end

  scope "/", HergettoWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live "/login", LoginLive
  end

  scope "/auth", HergettoWeb do
    pipe_through [:browser]

    get "/logout", AuthController, :logout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", HergettoWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HergettoWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      surface_catalogue("/catalogue")
    end
  end
end
