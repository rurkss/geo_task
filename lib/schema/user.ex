defmodule GeoTask.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias GeoTask.Schema.User
  alias GeoTask.Repo

  schema "users" do
    field(:token, :string)
    field(:role, :string)

    has_many(:driver_task, GeoTask.Schema.Task, foreign_key: :driver)
    has_many(:manager_task, GeoTask.Schema.Task, foreign_key: :manager)
  end
end
