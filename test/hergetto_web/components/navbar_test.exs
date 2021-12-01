defmodule HergettoWeb.NavbarTest do
  use ExUnit.Case
  use Surface.LiveViewTest

  alias Elixir.HergettoWeb.Components.Navbar

  # The default endpoint for testing
  @endpoint Endpoint

  test "creates a <button> with class" do
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
end
