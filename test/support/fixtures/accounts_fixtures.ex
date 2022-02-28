defmodule Hergetto.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hergetto.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        external_id: "some external_id",
        profile_picture: "some profile_picture",
        profile_colour: "some profile_colour",
        provider: "google",
        email: "info@hergetto.live",
        tag: "1337",
        username: "some username"
      })
      |> Hergetto.Accounts.create_user()

    user
  end
end
