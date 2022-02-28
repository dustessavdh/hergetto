defmodule HergettoWeb.Helpers.GoogleAnalytics do
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers

  def google_analytics() do
    tracking_id = Application.get_env(:hergetto, HergettoWeb.Helpers.GoogleAnalytics, [tracking_id: nil])[:tracking_id]
    case {Mix.env(), tracking_id} do
      {:prod, tracking_id} when tracking_id in [nil, ""] ->
        nil
      {:prod, tracking_id} ->
        assigns = %{
          tracking_id: tracking_id
        }
        ~H"""
        <script data-cookiecategory="analytics" async src={"https://www.googletagmanager.com/gtag/js?id=" <> @tracking_id}></script>
        <script data-cookiecategory="analytics" nonce="ga">
          window.dataLayer = window.dataLayer || [];
          function gtag(){dataLayer.push(arguments);}
          gtag('js', new Date());
          gtag('config', '<%= @tracking_id %>');
        </script>
        """
      _ ->
        nil
    end
  end
end
