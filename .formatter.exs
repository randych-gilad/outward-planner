[
  inputs: [
    "{mix,.formatter}.exs",
    "{config,lib,test}/**/*.{ex,exs}",
    "priv/repo/migrations/*.exs"
  ],
  import_deps: [:ecto, :ecto_sql]
]
