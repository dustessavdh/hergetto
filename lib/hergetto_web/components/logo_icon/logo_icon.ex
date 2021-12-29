defmodule HergettoWeb.Components.LogoIcon do
  use Surface.Component

  prop icon, :map, default: %{
    type: "fontawesome",
    value: "fab fa-phoenix-framework"
  }
end
