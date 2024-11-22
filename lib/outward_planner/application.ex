defmodule OutwardPlanner.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OutwardPlanner.Repo
    ]

    opts = [strategy: :one_for_one, name: OutwardPlanner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# defmodule OutwardPlanner.Application do
#   @moduledoc false
#   use Application

#   @impl true
#   def start(_type, args \\ []) do
#     task =
#       Task.async(fn ->
#         OutwardPlanner.main(args)
#       end)

#     Task.await(task)
#     {:ok, self()}
#   end
# end
