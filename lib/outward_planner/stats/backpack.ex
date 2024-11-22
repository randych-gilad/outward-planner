defmodule OutwardPlanner.Stats.Backpack do
  @moduledoc """
  Backpack struct.

  Invent_prot refers to inventory protection.
  """
  use Ecto.Schema

  schema "backpacks" do
    field(:name, :string)
    field(:set, :string, default: "")
    field(:class, :string)
    field(:capacity, :integer, default: 0)
    field(:protection, :integer, default: 0)
    field(:invent_prot, :integer, default: 0)
    field(:status_resist, :integer, default: 0)
    field(:movespeed, :integer, default: 0)
    field(:stamina_cost_reduction, :integer, default: 0)
    field(:effects, :string, default: "")
    field(:preservation, :integer, default: 0)
    field(:physical_bonus, :integer, default: 0)
    field(:lightning_bonus, :integer, default: 0)
    field(:corruptresist, :integer, default: 0)
  end
end
