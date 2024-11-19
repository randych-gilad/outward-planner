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
