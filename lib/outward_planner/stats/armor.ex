defmodule OutwardPlanner.Stats.Armor do
  @moduledoc """
  Armor struct.

  Elements without bonus refer to resistance.

  Elements with bonus refer to % damage increase.
  """
  use Ecto.Schema

  schema "armor" do
    field(:name, :string)
    field(:class, :string)
    field(:type, :string)
    field(:set, :string, default: "")
    field(:protection, :integer, default: 0)
    field(:barrier, :integer, default: 0)
    field(:mana_cost_reduction, :integer, default: 0)
    field(:stamina_cost_reduction, :integer, default: 0)
    field(:movespeed, :integer, default: 0)
    field(:cooldown, :integer, default: 0)
    field(:effects, :string, default: "")
    field(:pouch, :integer, default: 0)
    field(:decay, :integer, default: 0)
    field(:decay_bonus, :integer, default: 0)
    field(:ethereal, :integer, default: 0)
    field(:ethereal_bonus, :integer, default: 0)
    field(:fire, :integer, default: 0)
    field(:fire_bonus, :integer, default: 0)
    field(:frost, :integer, default: 0)
    field(:frost_bonus, :integer, default: 0)
    field(:impact, :integer, default: 0)
    field(:lightning, :integer, default: 0)
    field(:lightning_bonus, :integer, default: 0)
    field(:physical, :integer, default: 0)
    field(:physical_bonus, :integer, default: 0)
    field(:coldresist, :integer, default: 0)
    field(:heatresist, :integer, default: 0)
    field(:corruptresist, :integer, default: 0)
    field(:status_resist, :integer, default: 0)
  end
end
