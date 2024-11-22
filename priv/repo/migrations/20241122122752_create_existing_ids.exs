defmodule OutwardPlanner.Repo.Migrations.CreateExistingIds do
  use Ecto.Migration

  def change do
    create table :existing_ids do
      add :pageid, :integer
      add :name, :string
    end

    create(unique_index(:existing_ids,~w(name)))
  end
end
