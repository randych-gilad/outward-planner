defmodule OutwardPlanner.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :name, :string
      add :effects, :string
      add :cooldown, :integer
      add :damage, :string
      add :duration, :integer
      add :staminacost, :integer
      add :manacost, :integer
      add :healthcost, :integer
      add :multipliers, :float
      add :damage_override, :string
      add :skilltype, :string
      add :skilltier, :integer
      add :subtype, :string
    end

    create unique_index(:skills, [:name])
  end
end
