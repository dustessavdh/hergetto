defmodule HergettoWeb.NavbarTest do
  use ExUnit.Case
  use Surface.LiveViewTest

  alias Elixir.HergettoWeb.Components.Navbar

  # The default endpoint for testing
  @endpoint Endpoint

  test "creates a <Navbar>" do
    html =
      render_surface do
        ~F"""
        <Navbar />
        """
      end

    assert html =~ """
           <nav class="navbar navbar-dark navbar-expand-lg justify-content-between">
           """
  end

  test "create a <Navbar> with a private room" do
    html =
      render_surface do
        ~F"""
        <Navbar room={%{name: 'The Cool Kid Room', private?: true}} />
        """
      end

    assert html =~ """
           <h4 class="nav-room-name text-truncate"><i class="fas fa-eye-slash"></i><span> ⋅ </span>The Cool Kid Room</h4>
           """
  end
end
