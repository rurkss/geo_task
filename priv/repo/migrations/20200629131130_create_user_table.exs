defmodule GeoTask.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:token, :string)
      add(:role, :string, null: false)
    end

    create index(:users, [:token])
  end
end
