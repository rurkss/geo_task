defmodule GeoTask.Schema.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias GeoTask.Repo
  alias GeoTask.Schema.Task
  alias GeoTask.Schema.User

  schema "tasks" do
    field(:location_from, Geo.PostGIS.Geometry)
    field(:location_to, Geo.PostGIS.Geometry)

    field(:status, :string)

    belongs_to(:driver, User)
    belongs_to(:manager, User)    
  end
end
