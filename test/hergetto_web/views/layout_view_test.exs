defmodule HergettoWeb.LayoutViewTest do
  use HergettoWeb.ConnCase, async: true

  alias HergettoWeb.LayoutView
  import Phoenix.HTML

  test "get default meta tags" do
    default_tags = LayoutView.meta_tags()
    |> Enum.map(fn tag -> safe_to_string tag end)

    assert Enum.member? default_tags, ~s|<meta content="Hergetto · Together in a safe way!" name="title">|
    assert Enum.member? default_tags, ~s|<meta content="phoenix watch youtube videos together hergetto" name="keywords">|
    assert Enum.member? default_tags, ~s|<meta content="summary" name="twitter:card">|
  end

  test "override default meta tags" do
    meta_attrs = [
      %{name: "title", content: "Hergetto is awesome!"},
      %{name: "keywords", content: "test exunit elixir"},
    ]

    tags = LayoutView.meta_tags(meta_attrs)
    |> Enum.map(fn tag -> safe_to_string tag end)

    assert Enum.member? tags, ~s|<meta content="Hergetto is awesome!" name="title">|
    assert Enum.member? tags, ~s|<meta content="test exunit elixir" name="keywords">|
    assert Enum.member? tags, ~s|<meta content="summary" name="twitter:card">|
  end
end
