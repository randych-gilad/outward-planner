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

  @spec new(atom()) :: String.t()
  def new(cmtitle) when is_atom(cmtitle) do
    params = %__MODULE__{cmtitle: cmtitle}

    params.base_url <>
      ([
         "action=" <>
           to_string(params.action),
         "list=" <>
           to_string(params.list),
         "cmtitle=Category:" <>
           (to_string(params.cmtitle) |> format_category()),
         "cmlimit=" <>
           to_string(params.cmlimit),
         "format=" <>
           to_string(params.format)
       ]
       |> Enum.join("&"))
  end

  defp format_category(category) do
    category
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join("%20")
  end
end

defmodule OutwardPlanner.Query.Page do
  @moduledoc """
  Build Wiki.gg REST API query for page result by id.

  Without prop, rvprop and rvslots API won't return page data.
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

  @spec new(non_neg_integer() | [non_neg_integer()]) :: String.t()
  def new(pageids) when is_integer(pageids) or is_list(pageids) do
    params = %__MODULE__{pageids: pageids}

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
