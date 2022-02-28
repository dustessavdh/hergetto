defmodule HergettoWeb.Helpers.GoogleAnalytics do
  @moduledoc """
  This module provides a function to load Google Analytics.
  """
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers

  def google_analytics do
    tracking_id =
      Application.get_env(:hergetto, HergettoWeb.Helpers.GoogleAnalytics, tracking_id: nil)[
        :tracking_id
      ]

    case tracking_id do
      id when id in [nil, ""] ->
        nil

      id when is_binary(id) ->
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
