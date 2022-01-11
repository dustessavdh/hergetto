defmodule HergettoWeb.Helpers.MetaTags do
  use Phoenix.HTML
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

  @doc """
  Renders a meta title tag with automatic prefix/suffix on `@page_title` updates.
  ## Examples
      <%= live_meta_title_tag assigns[:page_title] || "Welcome", prefix: "MyApp – " %>
      <%= live_meta_title_tag assigns[:page_title] || "Welcome", suffix: " – MyApp" %>
  """
  def live_meta_title_tag(title, opts \\ []) do
    meta_title_tag(title, opts[:prefix], opts[:suffix], opts)
  end

  defp meta_title_tag(title, nil = _prefix, "" <> suffix, _opts) do
    [
      tag(:meta, name: "title", content: title <> suffix),
      tag(:meta, name: "og:title", content: title <> suffix),
      tag(:meta, name: "twitter:title", content: title <> suffix)
    ]
  end


  defp meta_title_tag(title, "" <> prefix, nil = _suffix, _opts) do
    [
      tag(:meta, name: "title", content: prefix <> title),
      tag(:meta, name: "og:title", content: prefix <> title),
      tag(:meta, name: "twitter:title", content: prefix <> title)
    ]
  end

  defp meta_title_tag(title, "" <> pre, "" <> post, _opts) do
    [
      tag(:meta, name: "title", content: pre <> title <> post),
      tag(:meta, name: "og:title", content: pre <> title <> post),
      tag(:meta, name: "twitter:title", content: pre <> title <> post)
    ]
  end

  defp meta_title_tag(title, _prefix = nil, _postfix = nil, []) do
    [
      tag(:meta, name: "title", content: title),
      tag(:meta, name: "og:title", content: title),
      tag(:meta, name: "twitter:title", content: title)
    ]
  end

  defp meta_title_tag(_title, _prefix = nil, _suffix = nil, opts) do
    raise ArgumentError,
          "live_meta_title_tag/2 expects a :prefix and/or :suffix option, got: #{inspect(opts)}"
  end
end
