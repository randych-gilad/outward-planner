defmodule OutwardPlanner.Query.Page do
  @moduledoc """
  Build Wiki.gg REST API query for page result by id.

  Without prop, rvprop and rvslots API won't return page data.
  """
  @enforce_keys :pageids
  @type t :: %__MODULE__{
          action: atom(),
          pageids: non_neg_integer() | [non_neg_integer()],
          prop: atom(),
          rvprop: atom(),
          rvslots: atom(),
          format: atom()
        }
  defstruct action: :query,
            pageids: 0,
            prop: :revisions,
            rvprop: :content,
            rvslots: :main,
            format: :json

  @spec new(non_neg_integer() | [non_neg_integer()]) :: String.t()
  def new(pageids) when is_integer(pageids) or is_list(pageids) do
    OutwardPlanner.base_url() <>
      (%__MODULE__{pageids: parse_ids(pageids)}
       |> Map.from_struct()
       |> URI.encode_query())
  end

  defp parse_ids(page_ids) when is_list(page_ids) do
    page_ids
    |> Enum.join("|")
  end

  defp parse_ids(page_ids) when is_integer(page_ids) do
    page_ids
    |> to_string()
  end
end
