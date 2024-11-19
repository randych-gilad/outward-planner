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
               "https://outward.wiki.gg/api.php?action=query&pageids=2259&prop=revisions&rvprop=content&rvslots=main&format=json"
    end
  end

  test "get Zhorn's dagger struct" do
    with query <- OutwardPlanner.ApiRequest.request_page(:daggers),
         zhorn_dagger <-
           Enum.find(query, fn map -> map.name == "Zhorn's Glowstone Dagger" end) do
      assert zhorn_dagger == %OutwardPlanner.Stats.Weapon{
               name: "Zhorn's Glowstone Dagger",
               class: "Dagger",
               type: "Off-Handed",
               set: "Zhorn's Set",
               protection: 0,
               barrier: 0,
               impact_resistance: 0,
               mana_cost_reduction: 0,
               attackspeed: 1,
               effects: "Glowing (Light Source)",
               impact: 38,
               physical: 20,
               decay: 0,
               ethereal: 0,
               fire: 0,
               frost: 0,
               lightning: 9,
               stamcost: 0,
               physical_bonus: 0,
               decay_bonus: 0,
               ethereal_bonus: 0,
               fire_bonus: 0,
               frost_bonus: 0,
               lightning_bonus: 0
             }
    end
  end
end
