defmodule OutwardPlanner.ApiRequest do
  @moduledoc """
  Functionality to query Wiki.gg REST API for page IDs in categories and page content.
  """
  alias OutwardPlanner.Query
  alias OutwardPlanner.Stats

  def request_category(category) do
    HTTPoison.get!(Query.Category.new(category))
    |> case do
      %HTTPoison.Response{body: body} ->
        body
        |> Jason.decode!(keys: :atoms)
        |> Map.get(:query)
        |> Map.get(:categorymembers)
        |> Enum.map(&Map.delete(&1, :ns))

      %HTTPoison.Response{status_code: status} ->
        {:error, "category request status code: #{status}"}
    end
  end

  def request_page(category) do
    with pages <- request_category(category),
         pageids <-
           pages
           |> Enum.map(&Map.delete(&1, :title))
           |> Enum.map(&Map.values/1)
           |> List.flatten(),
         %HTTPoison.Response{body: body} <-
           HTTPoison.get!(Query.Page.new(pageids)) do
      body
      |> Jason.decode!(keys: :atoms)
      |> get_in([:query, :pages])
      |> extract_page_content()
    end
  end

  defp extract_page_content(%{} = page) do
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

  defp filter_stats(stat) when is_binary(stat) do
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
end
