defmodule OutwardPlanner.Query.Category do
  @moduledoc """
  Build Wiki.gg REST API query for category to be used in other modules.
  """
  @enforce_keys :cmtitle
  @type t :: %__MODULE__{
          action: atom(),
          list: atom(),
          cmtitle: atom(),
          cmlimit: atom(),
          format: atom()
        }
  defstruct action: :query,
            list: :categorymembers,
            cmtitle: :empty,
            cmlimit: :max,
            format: :json

  @spec new(atom()) :: String.t()
  def new(category) when is_atom(category) do
    OutwardPlanner.base_url() <>
      (%__MODULE__{cmtitle: format_category(category)}
       |> Map.from_struct()
       |> URI.encode_query())
  end

  defp format_category(category) do
    "Category:" <>
      (category
       |> to_string()
       |> String.split("_")
       |> Enum.map(&String.capitalize/1)
       |> Enum.join("%20"))
  end
end
