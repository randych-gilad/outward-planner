defmodule OutwardPlanner.ApiRequest do
  @moduledoc """
  Functionality to query Wiki.gg REST API for page IDs in categories and page content.
  """

  def request_category(category) do
    HTTPoison.get!(OutwardPlanner.Query.build(cmtitle: category))
    |> case do
      {:ok, body} -> body
    end
  end
end
