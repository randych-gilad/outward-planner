defmodule OutwardPlanner.Query.Parser do
  @moduledoc """
  Module to parse JSON data received from queries.
  """
  alias OutwardPlanner.Stats

  @mainhand ~w(Axes Bows Maces Polearms Spears Swords Gauntlets)
  @offhand ~w(Chakrams Daggers Pistols Lanterns Lexicons Shields)
  @weapons @mainhand ++ @offhand
  @armor ~w(Helmets Chest Boots Backpacks) ++ ["Body Armor"]

  def extract_page_content(%{} = page) do
    page
    |> Map.values()
    |> Enum.map(fn page ->
      title = page["title"]

      content =
        List.first(page["revisions"])["slots"]["main"]["*"]

      content
      |> String.split("\n|", trim: true)
      |> Enum.filter(&filter_stats/1)
      |> Enum.map(&format_stats/1)
      |> Enum.map(fn [k, v] ->
        atom_key = format_struct_key(k)
        parsed_value = format_number(v)
        {atom_key, parsed_value}
      end)
      |> Enum.into(%{})
      |> Map.put(:name, title)
    end)
    |> Enum.reject(&exclude_category_page/1)
    |> Enum.map(&exclude_empty_values/1)
    |> Enum.map(&struct!(decide_class!(&1), &1))
  end

  def filter_stats(stat) when is_binary(stat) do
    !String.contains?(stat, [
      "{{",
      "}}",
      "image",
      "object id",
      "ingredient",
      "style",
      "buy",
      "sell",
      "related",
      "DLC",
      "weight",
      "durability",
      "size",
      "reach",
      "manual",
      "prereq",
      "action0",
      "action1",
      "action2",
      "location",
      "blacksmith",
      "station",
      "slot"
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

  defp format_number(number) when is_binary(number) do
    case Float.parse(number) do
      :error ->
        number

      {parsed_number, _} ->
        Float.round(parsed_number)
    end
  end

  defp exclude_category_page(page) do
    page.name in (@weapons ++ @armor)
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

  defp decide_class!(%{class: class} = item) do
    classes = category_to_class()

    case class do
      "Backpack" ->
        %Stats.Backpack{}

      "Body Armor" ->
        %Stats.Armor{class: "Chest"}

      "Head" ->
        %Stats.Armor{class: "Helmet"}

      class when class in ["Foot", "Legs"] ->
        %Stats.Armor{class: "Boots"}

      _ ->
        cond do
          class in classes.weapons -> %Stats.Weapon{}
          class in classes.armor -> %Stats.Armor{}
          true -> raise KeyError, {:error, item}
        end
    end
  end
end
