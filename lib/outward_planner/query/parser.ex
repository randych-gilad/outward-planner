defmodule OutwardPlanner.Query.Parser do
  @moduledoc """
  Module to parse JSON data received from queries.
  """
  alias OutwardPlanner.Stats

  @mainhand ~w(Axes Bows Maces Polearms Spears Swords Gauntlets)
  @offhand ~w(Chakrams Daggers Pistols Lanterns Lexicons Shields)
  @weapons @mainhand ++ @offhand
  @armor ~w(Helmets Boots Backpacks) ++ ["Body Armor"]
  @skills ~w(Breakthrough Skills)
  @skill_class [
    "Kazite Spellblade",
    "Mercenary",
    "Passive Skills",
    "Hex Mage",
    "Philosopher",
    "Rune Sage",
    "Primal Ritualist",
    "Rogue Engineer",
    "Weapon Master",
    "Warrior Monk",
    "Wild Hunter",
    "The Speedster",
    "Specialist"
  ]
  @unwanted_pages @weapons ++
                    @armor ++
                    @skills ++
                    @skill_class ++
                    [
                      "Call to Elements",
                      "Cabal Hermit",
                      "Jinx",
                      "Shamanic Resonance",
                      "Probe",
                      "Sigils",
                      "Skill preload",
                      "Template:Skill preload",
                      "Category:Skill Combinations",
                      "Category:Active Skills",
                      "Category:Passive Skills",
                      "Skill Combinations"
                    ]

  def extract_page_content(%{} = page) do
    page
    |> Map.values()
    |> Enum.reject(&exclude_category_page/1)
    |> Enum.map(fn page ->
      name = page["title"]

      content =
        List.first(page["revisions"])["slots"]["main"]["*"]

      content
      |> String.split("\n|", trim: true)
      |> Enum.filter(&filter_stats/1)
      |> Enum.map(&format_stats/1)
      |> Enum.map(fn [k, v] ->
        atom_key = format_struct_key(k)
        parsed_value = format_struct_value(v)
        {atom_key, parsed_value}
      end)
      |> Enum.into(%{})
      |> Map.put(:name, name)
    end)
    |> Enum.map(&exclude_empty_values/1)
    |> Enum.map(&struct!(decide_struct_category!(&1), &1))
  end

  def filter_stats(stat) when is_binary(stat) do
    !String.contains?(stat, [
      "{{",
      "}}",
      "image",
      "description",
      "object",
      "count",
      "cost",
      "ingredient",
      "style",
      "buy",
      "sell",
      "related",
      "DLC",
      "weight",
      "durability",
      "size",
      "value",
      "hunger",
      "drink",
      "rest",
      "reach",
      "manual",
      "prereq",
      "requires",
      "consumes",
      "sourceType",
      "valueType",
      "action0",
      "action1",
      "action2",
      "multipliers",
      "location",
      "blacksmith",
      "station",
      "slot",
      "trainer",
      "quest",
      "notes"
    ])
  end

  defp format_stats(stat) when is_binary(stat) do
    stat
    |> String.replace(["[[", "]]"], "")
    |> String.split("=")
    |> Enum.map(&String.trim/1)
  end

  defp format_struct_key(key) when is_binary(key) do
    key
    |> Macro.underscore()
    |> String.to_atom()
  end

  defp format_struct_value(value) when is_binary(value) do
    case Float.parse(value) do
      :error ->
        cond do
          value in ["Starter", "Instant", "permanent"] ->
            0

          value == "Quest" ->
            4

          String.contains?(value, "None") ->
            0

          true ->
            value
        end

      {parsed_number, _} ->
        case String.contains?(value, ".0") do
          true ->
            Float.round(parsed_number)

          false ->
            case String.starts_with?(value, "+") do
              true -> value
              false -> trunc(parsed_number)
            end
        end
    end
  end

  defp exclude_category_page(page) do
    page["title"] in @unwanted_pages
  end

  defp exclude_empty_values(pages) do
    pages
    |> Map.filter(fn {_k, v} -> v != "" end)
  end

  defp category_to_class do
    %{weapons: @weapons, armor: @armor}
    |> Map.new(fn {key, categories} ->
      {key,
       categories
       |> Enum.map(fn category ->
         case category do
           "Boots" -> "Boots"
           other -> String.trim_trailing(other, "s")
         end
       end)}
    end)
  end

  defp decide_struct_category!(%{name: _, skilltype: _}) do
    %Stats.Skill{}
  end

  defp decide_struct_category!(%{name: name, class: class}) do
    classes = category_to_class()

    case class do
      "Backpack" ->
        %Stats.Backpack{}

      class when class in ["Body Armor", "Chest"] ->
        %Stats.Armor{class: "Chest"}

      "Head" ->
        %Stats.Armor{class: "Helmet"}

      class when class in ["Foot", "Legs"] ->
        %Stats.Armor{class: "Boots"}

      _ ->
        cond do
          class in classes.weapons -> %Stats.Weapon{}
          class in classes.armor -> %Stats.Armor{}
          true -> raise ArgumentError, "Invalid class #{class} of item #{name}"
        end
    end
  end

  defp decide_struct_category!(%{name: name} = item) do
    IO.inspect(item)
    raise ArgumentError, "Invalid item of name #{name}"
  end
end
