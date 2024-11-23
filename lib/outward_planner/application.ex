defmodule OutwardPlanner.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OutwardPlannerWeb.Telemetry,
      OutwardPlanner.Repo,
      {Phoenix.PubSub, name: OutwardPlanner.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: OutwardPlanner.Finch},
      OutwardPlannerWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: OutwardPlanner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OutwardPlannerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
