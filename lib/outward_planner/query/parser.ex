defmodule OutwardPlanner.Query.Parser do
  @moduledoc """
  Module to parse JSON data received from queries.
  """
  alias __MODULE__.WikiAPIError
  alias OutwardPlanner.Stats

  @mainhand ~w(Axes Bows Maces Polearms Spears Swords Gauntlets)
  @offhand ~w(Chakrams Daggers Pistols Lanterns Lexicons Shields)
  @weapons @mainhand ++ @offhand
  @armor ~w(Helmets Boots Backpacks) ++ ["Body Armor"]

  def decode_page_content!(body) do
    body
    |> Jason.decode!()
    |> raise_api_error!()
    |> get_in(["query", "pages"])
  end

  defp raise_api_error!(%{"error" => error}) do
    message = error["info"] || "Unknown API error"
    raise WikiAPIError, message: "API Error: #{message}"
  end

  defp raise_api_error!(response), do: response

  def extract_page_content(nil) do
    raise ArgumentError, message: "Category input could not produce valid answer"
  end

  def extract_page_content(%{} = page) do
    page
    |> Map.values()
    |> Enum.map(fn page ->
      title = page["title"]

      content =
        page["revisions"]
        |> List.first()
        |> Map.get("slots")
        |> Map.get("main")

      content
      |> Map.get("*")
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
    |> Enum.map(&struct!(%Stats.Weapon{}, &1))
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
      "reach"
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
    page.name in @weapons
  end

  defp exclude_empty_values(pages) do
    pages
    |> Map.filter(fn {_k, v} -> v != "" end)
  end
end
