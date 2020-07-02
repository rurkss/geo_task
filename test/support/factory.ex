defmodule GeoTask.Factory do
  alias GeoTask.Schema.{Task, User}
  alias GeoTask.Repo

  def build(:driver) do
    %User{token: Ecto.UUID.generate(), role: "driver"}
  end

  def build(:manager) do
    %User{token: Ecto.UUID.generate(), role: "manager"}
  end

  def build(:task) do
    %Task{
      geopostions: [
        %{
          long: Faker.Address.longitude(),
          lat: Faker.Address.latitude()
        },
        %{
          long: Faker.Address.longitude(),
          lat: Faker.Address.latitude()
        }
      ]
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
