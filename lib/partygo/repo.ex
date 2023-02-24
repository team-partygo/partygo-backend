defmodule Partygo.Repo do
  use Ecto.Repo,
    otp_app: :partygo,
    adapter: Ecto.Adapters.Postgres
end
