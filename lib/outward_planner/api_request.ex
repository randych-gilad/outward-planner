defmodule OutwardPlanner.ApiRequest do
  @moduledoc """
  Functionality to query Wiki.gg REST API for page IDs in categories and page content.
  """

  def request_category(category) do
    HTTPoison.get!(
      OutwardPlanner.Query.Category.build(%OutwardPlanner.Query.Category{cmtitle: category})
    )
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
           HTTPoison.get!(
             OutwardPlanner.Query.Page.build(%OutwardPlanner.Query.Page{pageids: pageids})
           ) do
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
      |> Enum.filter(fn elem ->
        !String.contains?(elem, [
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
      end)
      |> Enum.map(&format_stats/1)
      |> Enum.map(fn [k, v] ->
        atom_key = k |> Macro.underscore() |> String.to_atom()

        parsed_value =
          case Integer.parse(v) do
            :error ->
              v

            {value_int, _} ->
              value_int
          end

        {atom_key, parsed_value}
      end)
      |> Enum.into(%{})
      |> Map.put(:name, title)
    end)
    |> Enum.map(&Map.filter(&1, fn {_k, v} -> v != "" end))
    |> Enum.map(&struct!(%OutwardPlanner.Stats.Weapon{}, &1))
  end

  defp format_stats(stats) when is_binary(stats) do
    stats
    |> String.replace(["[[", "]]"], "")
    |> String.split("=")
    |> Enum.map(&String.trim/1)
  end
end
