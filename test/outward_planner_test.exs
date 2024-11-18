defmodule OutwardPlannerTest do
  use ExUnit.Case
  doctest OutwardPlanner

  test "default", args do
    assert OutwardPlanner.main(args) == :ok
  end

  test "build category members query" do
    with query <- %OutwardPlanner.Query{cmtitle: :daggers} do
      assert OutwardPlanner.Query.build(query) ==
               "https://outward.wiki.gg/api.php?action=query&list=categorymembers&cmtitle=Category:Daggers&cmlimit=max&format=json"
    end
  end
end
