defmodule Hergetto.AccountsTest do
  use Hergetto.DataCase

  alias Hergetto.Accounts

  describe "Users" do
    alias Hergetto.Accounts.User

    import Hergetto.AccountsFixtures

    @invalid_attrs %{external_id: nil, profile_picture: nil, provider: nil, tag: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user(user.id) == user
    end

    test "get_user/2 returns the user with given external_id" do
      user = user_fixture()
      assert Accounts.get_user(user.external_id, :external_id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{external_id: "some external_id", profile_picture: "some profile_picture", provider: "some provider", tag: "1337", username: "some username"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.external_id == "some external_id"
      assert user.profile_picture == "some profile_picture"
      assert user.provider == "some provider"
      assert user.tag == "1337"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{external_id: "some updated external_id", profile_picture: "some updated profile_picture", provider: "some updated provider", tag: "1338", username: "some updated username"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.external_id == "some updated external_id"
      assert user.profile_picture == "some updated profile_picture"
      assert user.provider == "some updated provider"
      assert user.tag == "1338"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
