defmodule OutwardPlanner.Repo do
  use Ecto.Repo,
    otp_app: :outward_planner,
    adapter: Ecto.Adapters.SQLite3
end
