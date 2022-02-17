defmodule HergettoWeb.Components.Navbar.Example02 do
  @moduledoc """
  Example using the `user` property.
  """

  use Surface.Catalogue.Example,
    subject: Elixir.HergettoWeb.Components.Navbar,
    height: "480px",
    title: "User"

  alias Elixir.HergettoWeb.Components.Navbar

  def render(assigns) do
    ~F"""
    <Navbar
      user={%{
        external_id: "123456789",
        profile_picture: "https://file.coffee/u/Gd9Dyk1tZHbmpl.jpg",
        provider: "google",
        username: "coolkid",
        tag: 1337
      }}
    />
    """
  end
end
