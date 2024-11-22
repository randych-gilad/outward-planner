defmodule OutwardPlanner.Schema.Weapon do
  use Ecto.Schema

  schema "weapons" do
    field(:name, :string)
    field(:class, :string)
    field(:type, :string)
    field(:set, :string)
    field(:protection, :integer)
    field(:barrier, :integer)
    field(:impact_resistance, :integer)
    field(:mana_cost_reduction, :integer)
    field(:stamcost, :integer)
    field(:attackspeed, :integer)
    field(:effects, :string)
    field(:impact, :integer)
    field(:physical, :integer)
    field(:physical_bonus, :integer)
    field(:decay, :integer)
    field(:decay_bonus, :integer)
    field(:ethereal_bonus, :integer)
    field(:ethereal, :integer)
    field(:fire, :integer)
    field(:fire_bonus, :integer)
    field(:frost, :integer)
    field(:frost_bonus, :integer)
    field(:lightning, :integer)
    field(:lightning_bonus, :integer)
  end
end
