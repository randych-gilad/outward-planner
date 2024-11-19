defmodule OutwardPlannerTest do
  use ExUnit.Case
  doctest OutwardPlanner

  alias OutwardPlanner.Query
  alias OutwardPlanner.Stats

  @tag :local
  test "default", args do
    assert OutwardPlanner.main(args) == :ok
  end

  @tag :local
  test "build category members list query" do
    assert Query.Category.new(:daggers) ==
             "https://outward.wiki.gg/api.php?action=query&list=categorymembers&cmtitle=Category:Daggers&cmlimit=max&format=json"
  end

  @tag :local
  test "build category member query" do
    assert Query.Page.new(2259) ==
             "https://outward.wiki.gg/api.php?action=query&pageids=2259&prop=revisions&rvprop=content&rvslots=main&format=json"
  end

  @tag :api
  test "format Zhorn's dagger data to struct" do
    with query <- OutwardPlanner.ApiRequest.request_page(:daggers),
         zhorn_dagger <-
           Enum.find(query, fn map -> map.name == "Zhorn's Glowstone Dagger" end) do
      assert zhorn_dagger == %Stats.Weapon{
               attackspeed: 1.0,
               barrier: 0,
               class: "Dagger",
               decay: 0,
               decay_bonus: 0,
               effects: "Glowing (Light Source)",
               ethereal: 0,
               ethereal_bonus: 0,
               fire: 0,
               fire_bonus: 0,
               frost: 0,
               frost_bonus: 0,
               impact: 38.0,
               impact_resistance: 0,
               lightning: 10.0,
               lightning_bonus: 0,
               mana_cost_reduction: 0,
               name: "Zhorn's Glowstone Dagger",
               physical: 20.0,
               physical_bonus: 0,
               protection: 0,
               set: "Zhorn's Set",
               stamcost: 0,
               type: "Off-Handed"
             }
    end
  end
end
