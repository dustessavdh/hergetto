defmodule HergettoWeb.Components.LogoIcon do
  use Surface.Component
  alias HergettoWeb.Router.Helpers, as: Routes

  prop icon, :map, default: %{
    type: "fontawesome",
    value: "fab fa-phoenix-framework"
  }
end
