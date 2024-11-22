defmodule OutwardPlanner.Repo.Migrations.CreateArmor do
  use Ecto.Migration

  def change do
    create table :armor do
      add(:name, :string)
      add(:class, :string)
      add(:type, :string)
      add(:set, :string)
      add(:protection, :integer)
      add(:barrier, :integer)
      add(:mana_cost_reduction, :integer)
      add(:stamina_cost_reduction, :integer)
      add(:movespeed, :integer)
      add(:cooldown, :integer)
      add(:effects, :string)
      add(:pouch, :integer)
      add(:decay, :integer)
      add(:decay_bonus, :integer)
      add(:ethereal, :integer)
      add(:ethereal_bonus, :integer)
      add(:fire, :integer)
      add(:fire_bonus, :integer)
      add(:frost, :integer)
      add(:frost_bonus, :integer)
      add(:impact, :integer)
      add(:lightning, :integer)
      add(:lightning_bonus, :integer)
      add(:physical, :integer)
      add(:physical_bonus, :integer)
      add(:coldresist, :integer)
      add(:heatresist, :integer)
      add(:corruptresist, :integer)
      add(:status_resist, :integer)
    end

  create unique_index(:armor, [:name])
  end
end
