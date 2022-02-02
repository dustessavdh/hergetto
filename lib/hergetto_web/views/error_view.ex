defmodule HergettoWeb.ErrorView do
  use HergettoWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

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
