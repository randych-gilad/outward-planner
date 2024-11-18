defmodule OutwardPlannerTest do
  use ExUnit.Case
  doctest OutwardPlanner

  test "default", args do
    assert OutwardPlanner.main(args) == :ok
  end

  test "build category members list query" do
    with query <- %OutwardPlanner.Query.Category{cmtitle: :daggers} do
      assert OutwardPlanner.Query.Category.build(query) ==
               "https://outward.wiki.gg/api.php?action=query&list=categorymembers&cmtitle=Category:Daggers&cmlimit=max&format=json"
    end
  end

  test "build category member query" do
    with query <- %OutwardPlanner.Query.Page{pageids: 2259} do
      assert OutwardPlanner.Query.Page.build(query) ==
               "https://outward.wiki.gg/api.php?action=query&pageids=2259&format=json"
    end
  end
end
