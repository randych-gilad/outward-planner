defmodule OutwardPlanner.Stats.Weapon do
  @moduledoc """
  Weapon schema.

  Elements without bonus refer to flat damage.

  Elements with bonus refer to % damage increase.
  """
  use Ecto.Schema

  schema "weapons" do
    field :name, :string
    field :class, :string
    field :type, :string, default: ""
    field :set, :string, default: ""
    field :protection, :integer, default: 0
    field :barrier, :integer, default: 0
    field :impact_resistance, :integer, default: 0
    field :mana_cost_reduction, :integer, default: 0
    field :stamcost, :integer, default: 0
    field :attackspeed, :integer, default: 0
    field :effects, :string, default: ""
    field :impact, :integer, default: 0
    field :physical, :integer, default: 0
    field :physical_bonus, :integer, default: 0
    field :decay, :integer, default: 0
    field :decay_bonus, :integer, default: 0
    field :ethereal_bonus, :integer, default: 0
    field :ethereal, :integer, default: 0
    field :fire, :integer, default: 0
    field :fire_bonus, :integer, default: 0
    field :frost, :integer, default: 0
    field :frost_bonus, :integer, default: 0
    field :lightning, :integer, default: 0
    field :lightning_bonus, :integer, default: 0
  end
end
