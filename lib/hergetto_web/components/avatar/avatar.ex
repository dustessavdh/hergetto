defmodule HergettoWeb.Components.Avatar do
  use HergettoWeb, :component

  @doc """
  The user to display the avatar for.

  ## Examples

      %{
        external_id: "123456789",
        profile_picture: "/assets/images/avatar/default.png",
        profile_color: "#6D28D9",
        provider: "google",
        email: "info@hergetto.live",
        username: "coolkid",
        tag: 1337
      }
  """
  prop user, :map, required: true

  @doc "Class or classes to apply to the LogoIcon"
  prop class, :css_class, default: []
end
