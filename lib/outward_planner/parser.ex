defmodule OutwardPlanner.Query.Parser do
  @moduledoc """
  Module to parse JSON data received from queries.
  """
  alias OutwardPlanner.Stats

  def decode_to_page_content(body) do
    body
    |> Jason.decode!(keys: :atoms)
    |> get_in([:query, :pages])
  end

  def extract_page_content(%{} = page) do
    page
    |> Map.values()
    |> Enum.map(fn page ->
      title = page.title

      content =
        page.revisions
        |> List.first()
        |> Map.get(:slots)
        |> Map.get(:main)

      content
      |> Map.get(:*)
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
    |> Enum.map(&Map.filter(&1, fn {_k, v} -> v != "" end))
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

  def format_stats(stat) when is_binary(stat) do
    stat
    |> String.replace(["[[", "]]"], "")
    |> String.split("=")
    |> Enum.map(&String.trim/1)
  end

  def format_struct_key(key) when is_binary(key) do
    key
    |> Macro.underscore()
    |> String.to_atom()
  end

  def format_number(number) when is_binary(number) do
    case Float.parse(number) do
      :error ->
        number

      {parsed_number, _} ->
        Float.round(parsed_number)
    end
  end
end
