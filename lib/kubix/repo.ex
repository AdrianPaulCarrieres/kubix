defmodule Kubix.Repo do
  use Ecto.Repo,
    otp_app: :kubix,
    adapter: Ecto.Adapters.Postgres
end
