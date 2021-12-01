defmodule HergettoWeb.Components.Navbar.Example01 do
  @moduledoc """
  Example using the `room_name` and `private?` properties.
  """

  use Surface.Catalogue.Example,
    subject: Elixir.HergettoWeb.Components.Navbar,
    height: "480px",
    title: "Room info"

  alias Elixir.HergettoWeb.Components.Navbar

  def render(assigns) do
    ~F"""
    <Navbar room_name="The Cool Public Room" />
    <Navbar
      room_name="The Cool Privatge Room"
      private? ={true}
    />
    """
  end
end
