defmodule GeoTask.Factory do

  alias GeoTask.Schema.Task
  alias GeoTask.Schema.User

  def build(:driver) do
    %User{token: Ecto.UUID.generate(), role: "driver"}
  end

  def build(:manager) do
    %User{token: Ecto.UUID.generate(), role: "manager"}
  end

  def build(:task) do
    %Task{}
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

end
