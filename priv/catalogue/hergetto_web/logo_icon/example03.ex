defmodule HergettoWeb.Components.LogoIcon.Example03 do
  @moduledoc """
  Example for a letter.
  """

  use Surface.Catalogue.Example,
    subject: Elixir.HergettoWeb.Components.LogoIcon,
    height: "500px",
    title: "Logo icon with a letter"

  alias Elixir.HergettoWeb.Components.LogoIcon

  def render(assigns) do
    ~F"""
    <div style="height: 300px; width: 300px; display: block;">
      <LogoIcon icon={%{
        type: "letter",
        value: "A"
      }}/>
    </div>
    """
  end
end
