defmodule HergettoWeb.Components.Example do
  use HergettoWeb, :surface_component

  prop name, :string, required: true

  def render(assigns) do
    ~H"""
      <div>
        <h1>Welcome to {{ @name }}!</h1>
        <p>Peace of mind from prototype to production</p>
      </div>
    """
  end
end
