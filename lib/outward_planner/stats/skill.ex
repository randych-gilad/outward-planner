defmodule OutwardPlanner.Stats.Skill do
  @moduledoc """
  Skill schema.

  Non-empty subtype can identify a breakthrough.
  """
  use Ecto.Schema

  schema "skills" do
    field :name, :string
    field :effects, :string, default: ""
    field :cooldown, :integer, default: 0
    field :damage, :string, default: ""
    field :duration, :integer, default: 0
    field :staminacost, :integer, default: 0
    field :manacost, :integer, default: 0
    field :healthcost, :integer, default: 0
    field :multipliers, :float, default: 0.0
    field :damage_override, :string, default: ""
    field :skilltype, :string, default: ""
    field :skilltier, :integer, default: 0
    field :subtype, :string, default: ""
  end
end
