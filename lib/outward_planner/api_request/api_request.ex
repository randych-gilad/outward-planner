defmodule OutwardPlanner.ApiRequest do
  @moduledoc """
  Functionality to query Wiki.gg REST API for page IDs in categories and page content.
  """
  alias OutwardPlanner.Query
  alias OutwardPlanner.Repo

  def request_category(category) do
    Req.get!(Query.Category.new(category))
    |> case do
      %Req.Response{status: 200, body: body} ->
        body["query"]["categorymembers"]
        |> Enum.map(&Map.delete(&1, "ns"))

      %Req.Response{status: status} ->
        {:error, "category request status code: #{status}"}
    end
  end

  def request_pages(category) do
    with pages <- request_category(category),
         pageids <-
           pages
           |> Enum.map(&Map.delete(&1, "title"))
           |> Enum.map(&Map.values/1)
           |> List.flatten()
           |> Enum.chunk_every(50) do
      pageids
      |> Enum.map(&Req.get!(Query.Page.new(&1)))
      |> Enum.map(& &1.body["query"]["pages"])
      |> Enum.map(&Query.Parser.extract_page_content/1)
      |> Enum.concat()
      |> insert_pages()
    end
  end

  defp insert_pages(pages) do
    pages
    |> Enum.map(&Repo.insert!/1)
  end
end
