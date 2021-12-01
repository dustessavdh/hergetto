defmodule HergettoWeb.Components.Navbar do
  use Surface.Component

  @doc "The name of the room"
  prop room_name, :string

  @doc "Determines if the room is private or public"
  prop private?, :boolean

  @doc "Logged in user"
  prop user, :any

  @doc "Boolean to toggle if the dev routes should be shown"
  prop show_dev_routes?, :boolean
end
