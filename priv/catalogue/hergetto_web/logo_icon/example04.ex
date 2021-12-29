defmodule HergettoWeb.Components.LogoIcon.Example04 do
  @moduledoc """
  Example for a links.
  """

  use Surface.Catalogue.Example,
    subject: Elixir.HergettoWeb.Components.LogoIcon,
    height: "500px",
    title: "Logo icon with a link"

  alias Elixir.HergettoWeb.Components.LogoIcon

  def render(assigns) do
    ~F"""
    <div style="height: 300px; width: 300px; display: block;">
      <LogoIcon icon={%{
        type: "link",
        value: "https://file.coffee/u/YQczfq-YZ9dvfq.png"
      }}/>
    </div>
    """
  end
end
