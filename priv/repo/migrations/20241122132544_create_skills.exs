defmodule OutwardPlanner.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :name, :string
      add :effects, :string
      add :skilltype, :string
      add :skilltier, :integer
      add :subtype, :string
    end

    create unique_index(:skills, [:name])
  end
end
