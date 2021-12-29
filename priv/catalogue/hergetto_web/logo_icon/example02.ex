defmodule HergettoWeb.Components.LogoIcon.Example02 do
  @moduledoc """
  Example for fontawesome.
  """

  use Surface.Catalogue.Example,
    subject: Elixir.HergettoWeb.Components.LogoIcon,
    height: "500px",
    title: "Logo icon with fontawesome"

  alias Elixir.HergettoWeb.Components.LogoIcon

  def render(assigns) do
    ~F"""
    <div style="height: 300px; width: 300px; display: block;">
      <LogoIcon icon={%{
        type: "fontawesome",
        value: "fas fa-desktop"
      }}/>
    </div>
    """
  end
end
