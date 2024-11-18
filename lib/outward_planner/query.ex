defmodule OutwardPlanner.Query.Category do
  @moduledoc """
  Build Wiki.gg REST API query for category to be used in other modules.
  """
  @enforce_keys :cmtitle
  @type t :: %__MODULE__{
          base_url: String.t(),
          action: atom(),
          list: atom(),
          cmtitle: atom(),
          cmlimit: atom(),
          format: atom()
        }
  defstruct base_url: OutwardPlanner.base_url(),
            action: :query,
            list: :categorymembers,
            cmtitle: :empty,
            cmlimit: :max,
            format: :json

  def build(%__MODULE__{} = params) do
    params.base_url <>
      ([
         "action=" <>
           to_string(params.action),
         "list=" <>
           to_string(params.list),
         "cmtitle=Category:" <>
           (to_string(params.cmtitle) |> String.capitalize()),
         "cmlimit=" <>
           to_string(params.cmlimit),
         "format=" <>
           to_string(params.format)
       ]
       |> Enum.join("&"))
  end
end

defmodule OutwardPlanner.Query.Page do
  @moduledoc """
  Build Wiki.gg REST API query for page result by id.
  """
  @enforce_keys :pageids
  @type t :: %__MODULE__{
          base_url: String.t(),
          action: atom(),
          pageids: non_neg_integer() | [non_neg_integer()],
          format: atom()
        }
  defstruct base_url: OutwardPlanner.base_url(),
            action: :query,
            pageids: 0,
            prop: :revisions,
            rvprop: :content,
            rvslots: :main,
            format: :json

  # https://outward.wiki.gg/api.php?action=query&pageids=2259&format=json
  # https://outward.wiki.gg/api.php?action=query&pageids=2259&prop=revisions&rvprop=content&rvslots=main&format=json
  def build(%__MODULE__{} = params) do
    params.base_url <>
      ([
         "action=" <>
           to_string(params.action),
         "pageids=" <>
           parse_ids(params.pageids),
         "prop=" <>
           to_string(params.prop),
         "rvprop=" <>
           to_string(params.rvprop),
         "rvslots=" <>
           to_string(params.rvslots),
         "format=" <>
           to_string(params.format)
       ]
       |> Enum.join("&"))
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
