defmodule OutwardPlanner.ApiRequest do
  @moduledoc """
  Functionality to query Wiki.gg REST API for page IDs in categories and page content.
  """
  alias __MODULE__.WikiAPIError
  alias OutwardPlanner.Query

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

  def request_page(category) do
    with pages <- request_category(category),
         pageids <-
           pages
           |> Enum.map(&Map.delete(&1, "title"))
           |> Enum.map(&Map.values/1)
           |> List.flatten(),
         %Req.Response{body: body} <-
           Req.get!(Query.Page.new(pageids)) do
      case is_map_key(body, "error") do
        true ->
          message = body["error"]["info"] || "Unknown API error"
          pages = length(pageids)
          raise WikiAPIError, message: "API Error: #{message} Requested #{pages} values."

        _ ->
          Query.Parser.extract_page_content(body["query"]["pages"])
      end
    end
  end
end
