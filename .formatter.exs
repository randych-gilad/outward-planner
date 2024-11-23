[
  inputs: [
    "{mix,.formatter}.exs",
    "{config,lib,test}/**/*.{ex,exs}",
    "priv/repo/migrations/*.exs"
  ],
  import_deps: [:ecto, :ecto_sql],
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
    drop: 2
  ],
  export: [
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
      drop: 2
    ]
  ]
]
