defmodule HergettoWeb.Components.LogoIcon.Playground do
  use Surface.Catalogue.Playground,
    subject: HergettoWeb.Components.LogoIcon,
    height: "500px",
    body: [style: "padding: 1.5rem;"]

  data props, :map, default: %{
    icon: %{
      type: "link",
      value: "https://file.coffee/u/YQczfq-YZ9dvfq.png"
    },
  }

  def render(assigns) do
    ~F"""
    <div style="height: 400px; width: 400px; display: block;">
      <LogoIcon {...@props} />
    </div>
    """
  end
end
