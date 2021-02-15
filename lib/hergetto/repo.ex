defmodule Hergetto.Repo do
  use Ecto.Repo,
    otp_app: :hergetto,
    adapter: Ecto.Adapters.Postgres
end
