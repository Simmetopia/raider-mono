defmodule LetsRaid.Repo do
  use Ecto.Repo,
    otp_app: :letsraid,
    adapter: Ecto.Adapters.Postgres
end
