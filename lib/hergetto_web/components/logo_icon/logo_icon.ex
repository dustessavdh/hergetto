defmodule HergettoWeb.Components.LogoIcon do
  @moduledoc """
  A component that renders the empty Hergetto logo with a custom icon, letter, text or image
  """
  use HergettoWeb, :component
  alias HergettoWeb.Router.Helpers, as: Routes

  @doc "Icon to display on the empty Hergetto logo"
  prop icon, :map,
    default: %{
      type: "fontawesome",
      value: "fab fa-phoenix-framework"
    }

  @doc "Class or classes to apply to the LogoIcon"
  prop class, :css_class, default: []
end
