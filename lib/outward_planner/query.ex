defmodule OutwardPlanner.Query do
  # https://outward.wiki.gg/api.php?action=query&list=categorymembers&cmtitle=Category:Daggers&cmlimit=max&format=json
  @moduledoc """
  Build Wiki.gg REST API query to be used in other modules.
  """
  @type t :: %__MODULE__{
          base_url: String.t(),
          action: atom(),
          list: atom(),
          cmtitle: atom(),
          cmlimit: atom(),
          format: atom()
        }
  defstruct base_url: "https://outward.wiki.gg/api.php?",
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
