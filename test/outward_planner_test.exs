defmodule OutwardPlannerTest do
  use ExUnit.Case

  doctest OutwardPlanner

  alias OutwardPlanner.Query
  alias OutwardPlanner.Stats

  @weapon_test_json """
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
  @weapon_category_json """
  {
    "batchcomplete": "",
    "query": {
      "pages": {
        "7076": {
          "pageid": 7076,
          "ns": 0,
          "title": "Spears",
          "revisions": [
            {
              "slots": {
                "main": {
                  "contentmodel": "wikitext",
                  "contentformat": "text/x-wiki",
                  "*": "'''{{PAGENAME}}''' are thrusting two-handed [[weapons]] in ''[[Outward]]'' that are perfect for keeping your [[Enemies]] at bay. \\n\\nSpears reward high mobility, and are highly effective at making quick hits to enemies while outside their attack range, at the cost of relatively low [[Impact|impact damage]]. \\n\\n==Usage==\\n{{UsedInTraps|are}}\\n\\n==Spear Skills==\\n{{hatnote|<i>See also: [[Active_Skills#Melee_Weapon_Skills|Melee Weapon Skills]]</i>}}\\n* [[Simeon's Gambit]]\\n* [[Vicious Cycle]]{{The Three Brothers}}\\n\\n==List of Spears==\\n{{#invoke: list|items|category=Weapon|class=Spear|type=}}\\n\\n==Animations==\\n{{WeaponClass\\n| name = Spear\\n| type = \\n| lightDescription = Two forward-thrusting stabs\\n| lightTime = 1.508\\n| lightMP4 = Spear_Light.mp4\\n| lightHits = 2\\n| specialDmg = 1.4\\n| specialImpact = 1.2\\n| specialStam = 1.25\\n| specialDescription = Forward-lunging strike\\n| specialTime = 1.541\\n| specialMP4 = Spear_Heavy.mp4\\n| combo1Dmg = 1.3\\n| combo1Impact = 1.2\\n| combo1Stam = 1.25\\n| combo1Description = Left-sweeping strike, jump back\\n| combo1Time = 2.634\\n| combo1MP4 = Spear_Combo1.mp4\\n| combo2Dmg = 1.2\\n| combo2Impact = 1.1\\n| combo2Stam = 1.25\\n| combo2Description = Fast spinning strike from the right\\n| combo2Time = 3.712\\n| combo2MP4 = Spear_Combo2.mp4\\n}}\\n\\nOther combo patterns include:\\n* '''Sprint attack''': Performs a standard attack\\n* ''Combo 1'' > '''Special''' or ''Combo 2'' > '''Special''': Perform an attack equivalent to the Special attack\\n\\n==See Also==\\n* [[Equipment]]\\n\\n[[Category:Weapons]] [[Category:Spears]]"
                }}}]}}}}
  """

  @tag :local
  test "format Zhorn's dagger data to struct" do
    assert @weapon_test_json
           |> Query.Parser.decode_to_page_content()
           |> Query.Parser.extract_page_content()
           |> Enum.find(fn map -> map.name == "Zhorn's Glowstone Dagger" end) ==
             %Stats.Weapon{
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

  @tag :local
  test "weapon category page cannot fit into weapon struct" do
    assert_raise KeyError, fn ->
      @weapon_category_json
      |> Query.Parser.decode_to_page_content()
      |> Query.Parser.extract_page_content()
    end
  end
end
