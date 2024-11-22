import Config

config :outward_planner,
  ecto_repos: [OutwardPlanner.Repo]

config :outward_planner, OutwardPlanner.Repo,
  database: "../outward.db",
  pool_size: 5
