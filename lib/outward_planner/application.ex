# defmodule OutwardPlanner.Application do
#   # See https://hexdocs.pm/elixir/Application.html
#   # for more information on OTP Applications
#   @moduledoc false

#   use Application

#   @impl true
#   def start(_type, _args) do
#     children = [
#       # Starts a worker by calling: OutwardPlanner.Worker.start_link(arg)
#       # {OutwardPlanner.Worker, arg}
#     ]

#     # See https://hexdocs.pm/elixir/Supervisor.html
#     # for other strategies and supported options
#     opts = [strategy: :one_for_one, name: OutwardPlanner.Supervisor]
#     Supervisor.start_link(children, opts)
#   end
# end

defmodule OutwardPlanner.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, args \\ []) do
    task =
      Task.async(fn ->
        OutwardPlanner.main(args)
      end)

    Task.await(task)
    {:ok, self()}
  end
end
