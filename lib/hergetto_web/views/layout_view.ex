defmodule HergettoWeb.LayoutView do
  use HergettoWeb, :view

  @doc """
  Generates meta tags for the provided attributes.
  If none are provided it will use the default attributes specified in `config.exs`

  ## Parameters

  - attrs_list: The list of attributes

  To pass different attributes add them to the `assigns` of the `socket`/`conn`

  ### Example:

  ```elixir
  def mount(_params, _session, socket) do
    meta_attrs = [
      %{name: "title", content: "Welcome!"},
    ]

    {:ok, assign(socket, meta_attrs: meta_attrs)}
  end
  ```
  """
  def meta_tags(attrs_list \\ %{}) do
    Enum.map(Application.get_env(:hergetto, HergettoWeb.Meta), fn attr ->
      case find_attr_index(attr, attrs_list) do
        nil -> attr
        id -> Map.merge(attr, Enum.at(attrs_list, id))
      end
    end)
    |> Enum.map(&meta_tag/1)
  end

  defp meta_tag(attrs) do
    tag(:meta, Enum.into(attrs, []))
  end

  defp find_attr_index(attr, search_list) do
    Enum.find_index(search_list, fn search_attrs ->
      (Map.has_key?(search_attrs, :name) && search_attrs[:name] == attr[:name])
      || Map.has_key?(search_attrs, :property) && search_attrs[:property] == attr[:property]
    end)
  end
end
