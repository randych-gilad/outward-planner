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

  @tag :local
  test "format Zhorn's dagger data to struct" do
    with query <-
           """
           {
           "batchcomplete": "",
           "query": {
           "pages": {
           "4875": {
           "pageid": 4875,
           "ns": 0,
           "title": "Zhorn's Glowstone Dagger",
           "revisions": [
           {
            "slots": {
              "main": {
                "contentmodel": "wikitext",
                "contentformat": "text/x-wiki",
                "*": "{{Item weapon\\t\\n| name           = \\n| image          = Zhorn's Glowstone Dagger.png\\n| size           = 84px\\n| class          = Dagger\\n| type           = Off-Handed\\n| physical       = 20.1\\n| fire           = \\n| frost          = \\n| lightning      = 9.9\\n| ethereal       = \\n| decay          = \\n| impact         = 38\\n| reach          = 0.6643288\\n| attackspeed    = 1.0\\n| effects        = Glowing (Light Source)\\n| physicalBonus  = \\n| fireBonus      = \\n| frostBonus     = \\n| lightningBonus = \\n| etherealBonus  = \\n| decayBonus     = \\n| manaCostReduction       = \\n| durability     = 200\\n| weight         = 2.0\\n| buy            = 800\\n| sell           = 240\\n| related        = \\n| set = Zhorn's Set\\n| object id      = 5110005\\n| object name    = DaggerGlowstone\\n}}\\t\\n'''{{PAGENAME}}''' is a [[unique]] [[daggers|dagger]] that gives off as a little less light than a [[Old lantern]] when equipped.\\n\\n==Description==\\n{{Quote|A great hunter's knife that emits light.\u003Cbr\u003E\u003Cbr\u003EThis off-hand weapon requires Dagger skills to be used.}}\\n\\n==Acquired From==\\nCan be found in the [[Hallowed Marsh]] on the north-west most island.\\n\\nCrossing to the Island will require passing through the toxic waters of the Marsh and receiving [[Marsh High Poison]], so using an [[Elemental Immunity Potion]] or high [[Decay]] resistance armor is highly recommended.\\n\\nWhen you reach the island, head up the hill and go south-west. Cross through a hollowed tree bridge, then claim the dagger inside the second hollowed tree on the small island.\\n\\n* [[Media:ZhornsDaggerMap.png|Click here for a map of the location.]]\\n\\n==Enchantments==\\n{{UsedInEnchantments|tags=Weapon,Dagger}}\\n\\n==Notes==\\n* The actual lightning damage on the weapon is 9.900001\\n\\n==Gallery==\\n\u003Cgallery\u003E\\nZhornglowdaggerglow.png\\nZhorn's Glowstone Dagger.jpg\\n\u003C/gallery\u003E\\n\\n==See Also==\\n* [[Zhorn's Demon Shield]]\\n* [[Zhorn's Hunting Backpack]]\\n\\n{{Navbox weapons}}\\n\\n[[Category:Weapons]]\\n[[Category:Daggers]]\\n[[Category:Off-Handed Weapons]]"
              }}}]}}}}
           """
           |> Query.Parser.decode_to_page_content()
           |> Query.Parser.extract_page_content(),
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
