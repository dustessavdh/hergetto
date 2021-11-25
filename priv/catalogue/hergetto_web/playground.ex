defmodule HergettoWeb.Components.Hero.Playground do
  use Surface.Catalogue.Playground,
    subject: HergettoWeb.Components.Hero,
    height: "250px",
    body: [style: "padding: 1.5rem;"]

  data props, :map, default: %{
    subtitle: "Welcome to Surface!",
    color: "info"
  }

  def render(assigns) do
    ~F"""
    <Hero {...@props} />
    """
  end
end
