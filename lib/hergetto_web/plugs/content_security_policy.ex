defmodule HergettoWeb.Plugs.ContentSecurityPolicy do
  @moduledoc """
  This plug adds a Content-Security-Policy header to the response.
  """
  import Plug.Conn

  def put_content_security_policy_headers(conn, _opts) do
    merge_resp_headers(conn, [
      {
        "content-security-policy",
        "default-src 'self'; style-src 'self' 'unsafe-inline' *.typekit.net; font-src 'self' *.typekit.net; script-src 'self' 'nonce-ga' *.youtube.com www.google-analytics.com www.googletagmanager.com; img-src 'self' data: blob: *.googleusercontent.com www.google-analytics.com; frame-src 'self' *.youtube.com; connect-src 'self' www.google-analytics.com;"
      }
    ])
  end
end
