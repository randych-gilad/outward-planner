defmodule OutwardPlanner.Repo.Migrations.CreateBackpacks do
  use Ecto.Migration

  def change do
    create table(:backpacks) do
      add :name, :string
      add :set, :string
      add :class, :string
      add :capacity, :integer
      add :protection, :integer
      add :invent_prot, :integer
      add :status_resist, :integer
      add :movespeed, :integer
      add :stamina_cost_reduction, :integer
      add :effects, :string
      add :preservation, :integer
      add :physical_bonus, :integer
      add :lightning_bonus, :integer
      add :corruptresist, :integer
    end

    create unique_index(:backpacks, [:name])
  end
end
