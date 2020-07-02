defmodule GeoTask.TaskTest do
  use ExUnit.Case, async: true

  import GeoTask.Factory

  alias GeoTask.Schema.Task

  describe "changest task" do
    test "validate geoposition: failure if empty" do
      task = Task.changeset(%Task{}, %{})

      assert task.valid? == false
    end

    test "validate geoposition: failure if missing keys" do

      attrs = %{
        geopostions: [
          %{lat: Faker.Address.latitude()},
          %{lat: Faker.Address.latitude()}
        ]
      }

      task = Task.changeset(%Task{}, attrs)

      assert task.valid? == false
    end

    test "validate geoposition: failure if wrong geolocation format" do
      attrs = %{
        geopostions: [
          %{lat: Faker.Name.title(), long: Faker.Name.title()},
          %{lat: Faker.Name.title(), long: Faker.Name.title()}
        ]
      }

      task = Task.changeset(%Task{}, attrs)

      assert task.valid? == false
    end

    test "validate geoposition: success" do
      attrs = %{
        geopostions: [
          %{lat: Faker.Address.latitude(), long: Faker.Address.longitude()},
          %{lat: Faker.Address.latitude(), long: Faker.Address.longitude()}
        ]
      }
      task = Task.changeset(%Task{}, attrs)

      assert task.valid?
    end
  end

end
