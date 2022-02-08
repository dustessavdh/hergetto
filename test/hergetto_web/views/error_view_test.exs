defmodule HergettoWeb.ErrorViewTest do
  use HergettoWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  describe "Error view" do
    test "renders 500.html" do
      assert render_to_string(HergettoWeb.ErrorView, "500.html", []) == "Internal Server Error"
    end
  end
end
