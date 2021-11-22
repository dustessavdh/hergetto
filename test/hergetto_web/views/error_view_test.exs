defmodule HergettoWeb.ErrorViewTest do
  use HergettoWeb.ConnCase, async: true

  import Phoenix.View

  test "renders 500.html" do
    assert render_to_string(HergettoWeb.ErrorView, "500.html", []) == "Internal Server Error"
  end
end
