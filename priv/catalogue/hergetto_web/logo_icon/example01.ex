defmodule HergettoWeb.Components.LogoIcon.Example01 do
  @moduledoc """
  Example using the default values.
  """

  use Surface.Catalogue.Example,
    subject: Elixir.HergettoWeb.Components.LogoIcon,
    height: "500px",
    title: "Default Logo Icon"

  alias Elixir.HergettoWeb.Components.LogoIcon

  def render(assigns) do
    ~F"""
    <div style="height: 300px; width: 300px; display: block;">
      <LogoIcon />
    </div>
    """
  end
end
