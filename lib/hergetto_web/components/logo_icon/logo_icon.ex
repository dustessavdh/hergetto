defmodule HergettoWeb.Components.LogoIcon do
  @moduledoc """
  A component that renders the empty hergetto logo with a custom icon, letter, text or image
  """
  use Surface.Component
  alias HergettoWeb.Router.Helpers, as: Routes

  prop icon, :map,
    default: %{
      type: "fontawesome",
      value: "fab fa-phoenix-framework"
    }
end
