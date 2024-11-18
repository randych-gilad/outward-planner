defmodule OutwardPlanner.MixProject do
  use Mix.Project

  def project do
    [
      app: :outward_planner,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript_config()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {OutwardPlanner.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 2.0"}
    ]
  end

  defp escript_config do
    [
      main_module: OutwardPlanner,
      # escript hangs
      # path: ".escript/" <> app_name(),
      path: ".escript/outward_planner",
      strip_beams: true
    ]
  end
end
