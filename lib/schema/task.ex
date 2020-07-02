defmodule GeoTask.Schema.Task do
  use Ecto.Schema
  import Ecto.Changeset

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

  def changeset(task, attrs, %User{role: "manager"} = user) do
    task
    |> cast(attrs, [:geopostions, :status])
    |> validate_required([:geopostions])
    |> cast_geo_point()
    |> put_assoc(:manager, user)
  end

  def changeset(task, attrs, %User{role: "driver"} = user) do
    task
    |> cast(attrs, [:status])
    |> put_assoc(:driver, user)
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

  def find(id), do: Repo.get_by(__MODULE__, id: id) |> Repo.preload([:driver, :manager])

  def may_by_assigned?(task_id) do

    task = Task.find(task_id)

    case task.driver_id do
      nil -> :ok
      _ -> {:error, :task_already_assigned}
    end
  end

  def may_by_assigned?(nil), do: {:error, :task_not_found}

end
