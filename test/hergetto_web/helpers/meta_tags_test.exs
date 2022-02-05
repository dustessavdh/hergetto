defmodule HergettoWeb.MetaTagsTest do
  use HergettoWeb.ConnCase, async: true

  alias HergettoWeb.Helpers.MetaTags
  import Phoenix.HTML

  test "get default meta tags" do
    default_tags = MetaTags.meta_tags()
    |> Enum.map(fn tag -> safe_to_string tag end)

    assert Enum.member? default_tags, ~s|<meta content=\"#6D28D9\" name=\"theme-color\">|
    assert Enum.member? default_tags, ~s|<meta content=\"summary\" name=\"twitter:card\">|
    assert Enum.member? default_tags, ~s|<meta content=\"website\" property=\"og:type\">|
  end

  test "override default meta tags" do
    meta_attrs = [
      %{name: "keywords", content: "test exunit elixir"},
    ]

    tags = MetaTags.meta_tags(meta_attrs)
    |> Enum.map(fn tag -> safe_to_string tag end)

    assert Enum.member? tags, ~s|<meta content="test exunit elixir" name="keywords">|
    assert Enum.member? tags, ~s|<meta content="summary" name="twitter:card">|
  end
end
