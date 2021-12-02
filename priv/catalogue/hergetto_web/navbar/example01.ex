defmodule HergettoWeb.Components.Navbar.Example01 do
  @moduledoc """
  Example using the `room` property.
  """

  use Surface.Catalogue.Example,
    subject: Elixir.HergettoWeb.Components.Navbar,
    height: "480px",
    title: "Room info"

  alias Elixir.HergettoWeb.Components.Navbar

  def render(assigns) do
    ~F"""
    <Navbar
      room={%{
        name: "The Cool Kid Room",
        private?: true,
      }}
    />
    """
  end
end
