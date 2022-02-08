defmodule Hergetto.GuardianTest do
  use Hergetto.DataCase

  alias Hergetto.Authentication.Guardian

  describe "Guardian" do
    import Hergetto.AccountsFixtures

    test "subject_for_token/2 returns user id" do
      user = user_fixture()
      {:ok, id} = Guardian.subject_for_token(user, %{})

      assert id == user.id
    end

    test "resource_from_claims/1 returns user" do
      user = user_fixture()
      {:ok, user_from_claim} = Guardian.resource_from_claims(%{"sub" => user.id})

      assert user == user_from_claim
    end
  end
end
