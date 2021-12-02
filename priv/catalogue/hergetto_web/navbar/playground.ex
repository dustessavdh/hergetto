defmodule HergettoWeb.Components.Navbar.Playground do
  use Surface.Catalogue.Playground,
    subject: HergettoWeb.Components.Navbar,
    height: "250px",
    body: [style: "padding: 1.5rem;"]

  data props, :map, default: %{
    room: %{
      name: "The Cool Kid Room",
      private?: true
    },
  }

  def render(assigns) do
    ~F"""
    <Navbar {...@props} />
    """
  end
end
