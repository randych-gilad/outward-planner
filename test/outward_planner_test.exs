defmodule OutwardPlannerTest do
  use ExUnit.Case
  doctest OutwardPlanner

  test "default", args do
    assert OutwardPlanner.main(args) == :ok
  end
end
