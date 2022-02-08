defmodule HergettoWeb.Components.Navbar do
  @moduledoc """
  The navbar component
  """
  use HergettoWeb, :component
  alias HergettoWeb.Router.Helpers, as: Routes

  @doc """
  Info about the room.
  Only set this prop if the user is in a room.
  
  ## Examples
  
      %{
        :name => "The Cool Kid Room",
        :private? => true
      }
  """
  prop room, :map

  @doc """
  The current user.
  Only set this prop if the user is logged in.
  
  ## Examples
  
      %{
        external_id: "123456789",
        profile_picture: "https://file.coffee/u/Gd9Dyk1tZHbmpl.jpg",
        provider: "google",
        username: "coolkid",
        tag: 1337
      }
  """
  prop user, :map
end
