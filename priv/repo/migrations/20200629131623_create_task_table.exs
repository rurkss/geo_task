defmodule GeoTask.Repo.Migrations.CreateTaskTable do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add(:location_from, :geography)
      add(:location_to, :geography)

      add(:status, :string)
      add(:manager_id, references(:users))
      add(:driver_id, references(:users))
    end

    create(index(:tasks, [:location_from], using: :gist))
    create(index(:tasks, [:location_to], using: :gist))
    create index(:tasks, [:status])
    create index(:tasks, [:manager_id])
    create index(:tasks, [:driver_id])

  end
end
