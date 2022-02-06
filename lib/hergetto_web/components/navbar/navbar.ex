defmodule HergettoWeb.Components.Navbar do
  @moduledoc """
  The navbar component
  """
  use Surface.Component
  alias HergettoWeb.Router.Helpers, as: Routes

  prop room, :map

  @doc "Logged in user"
  prop user, :map
end
