defmodule OutwardPlanner.ApiRequest do
  @moduledoc """
  Functionality to query Wiki.gg REST API for page IDs in categories and page content.
  """
  alias OutwardPlanner.Query

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
      |> Query.Parser.decode_to_page_content()
      |> Query.Parser.extract_page_content()
    end
  end
end
