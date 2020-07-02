defmodule GeoTask.Schema.Task do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias GeoTask.Repo
  alias GeoTask.Schema.{Task, User}

  schema "tasks" do
    field(:location_from, Geo.PostGIS.Geometry)
    field(:location_to, Geo.PostGIS.Geometry)

    field(:status, :string)

    belongs_to(:driver, User)
    belongs_to(:manager, User)

    field(:geopostions, {:array, :map}, virtual: true)
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:geopostions])
    |> validate_required([:geopostions])
    |> cast_geo_point()
  end

  def cast_geo_point(
        %Ecto.Changeset{
          changes: %{
            geopostions: [%{long: long_from, lat: lat_from}, %{long: long_to, lat: lat_to}]
          },
          valid?: true
        } = changeset
      )
      when is_float(long_from) and is_float(lat_from) and is_float(long_to) and is_float(lat_to) do

    geo_from = %Geo.Point{coordinates: {long_from, lat_from}, srid: 4326}
    geo_to = %Geo.Point{coordinates: {long_to, lat_to}, srid: 4326}

    changeset
    |> put_change(:location_from, geo_from)
    |> put_change(:location_to, geo_to)
  end

  def cast_geo_point(changeset),
    do: add_error(changeset, :geopostions, "geopostions has to be a list with 2 elements")
end
