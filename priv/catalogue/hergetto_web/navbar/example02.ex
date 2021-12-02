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
        email: "keesvonkaas@gmail.com",
        external_id: 1337,
        profile_picture: "https://avatars.githubusercontent.com/u/25427808?v=4"
      }}
    />
    """
  end
end
