defmodule OutwardPlanner.Stats.Skill do
  @moduledoc """
  Skill schema.

  Non-empty subtype can identify a breakthrough.
  """
  use Ecto.Schema

  schema "skills" do
    field :name, :string
    field :effects, :string, default: ""
    field :skilltype, :string, default: ""
    field :skilltier, :integer, default: 0
    field :subtype, :string, default: ""
  end
end
