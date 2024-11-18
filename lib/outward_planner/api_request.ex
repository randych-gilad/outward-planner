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

  def request_page() do
    with pages <- request_category(:daggers),
         _pageids <-
           pages
           |> Enum.map(&Map.delete(&1, :title))
           |> Enum.map(&Map.values/1)
           |> List.flatten(),
         %HTTPoison.Response{body: body} <-
           HTTPoison.get!(
             OutwardPlanner.Query.Page.build(%OutwardPlanner.Query.Page{pageids: [100, 5097]})
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
      content =
        page.revisions
        |> List.first()
        |> Map.get(:slots)
        |> Map.get(:main)

      %{
        main:
          content
          |> Map.get(:*)
          |> String.split("\n|", trim: true)
          # |> Enum.slice(1, 27)
          |> Enum.filter(fn elem ->
            !String.contains?(elem, [
              "{{",
              "}}",
              "buy",
              "sell",
              "related",
              "DLC",
              "weight",
              "durability",
              "size"
            ])
          end)
          |> Enum.map(&format_stats/1)
      }
    end)
  end

  defp format_stats(stats) when is_binary(stats) do
    stats
    |> String.split("=")
    |> Enum.map(&String.trim/1)
  end
end
