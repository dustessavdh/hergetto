defmodule HergettoWeb.Components.Navbar do
  use Surface.Component

  prop room, :map

  @doc "Logged in user"
  prop user, :map

  @doc "Boolean to toggle if the dev routes should be shown"
  prop show_dev_routes?, :boolean
end
