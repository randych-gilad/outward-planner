defmodule OutwardPlanner.Repo.Migrations.CreateWeapons do
  use Ecto.Migration

  def change do
    create table(:weapons) do
      add :name, :string
      add :class, :string
      add :type, :string
      add :set, :string
      add :protection, :integer
      add :barrier, :integer
      add :impact_resistance, :integer
      add :mana_cost_reduction, :integer
      add :stamcost, :integer
      add :attackspeed, :integer
      add :effects, :string
      add :impact, :integer
      add :physical, :integer
      add :physical_bonus, :integer
      add :decay, :integer
      add :decay_bonus, :integer
      add :ethereal_bonus, :integer
      add :ethereal, :integer
      add :fire, :integer
      add :fire_bonus, :integer
      add :frost, :integer
      add :frost_bonus, :integer
      add :lightning, :integer
      add :lightning_bonus, :integer
    end

    create unique_index(:weapons, [:name])
  end
end
