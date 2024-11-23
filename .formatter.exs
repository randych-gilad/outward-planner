[
  inputs: [
    "{mix,.formatter}.exs",
    "{config,lib,test}/**/*.{ex,exs}",
    "priv/repo/migrations/*.exs"
  ],
  locals_without_parens: [
    add: 2,
    add: 3,
    remove: 2,
    remove: 3,
    modify: 2,
    modify: 3,
    create: 1,
    create: 2,
    create_if_not_exists: 1,
    create_if_not_exists: 2,
    drop: 1,
    drop: 2,
    get: 3,
    plug: 1,
    plug: 2,
    live: 2,
    pipe_through: 1,
    live_dashboard: 2,
    forward: 2
  ],
  import_deps: [:ecto, :ecto_sql]
]
