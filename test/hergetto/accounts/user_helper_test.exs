defmodule Hergetto.UserHelperTest do
  use ExUnit.Case

  describe "username generator" do
    alias Hergetto.Accounts.UserHelper, as: UH

    test "generate_username_with_tag/0 returns a username with tag" do
      username_with_tag = UH.generate_username_with_tag()
      [username, tag] = String.split(username_with_tag, "#")

      assert(String.match?(username, ~r/\w+/))
      assert(String.match?(tag, ~r/^\d{4}$/))
    end

    test "generate_guest_with_tag/0 returns a guest with tag" do
      guest_with_tag = UH.generate_guest_with_tag()
      [guest, tag] = String.split(guest_with_tag, "#")

      assert(String.match?(guest, ~r/\w+/))
      assert(String.match?(tag, ~r/^GUEST$/))
    end

    test "generate_username/0 returns a username" do
      username = UH.generate_username()
      assert(String.match?(username, ~r/\w+/))
    end

    test "generate_tag/0 returns a tag" do
      tag = UH.generate_tag()
      assert(String.match?(tag, ~r/^\d{4}$/))
    end
  end
end
