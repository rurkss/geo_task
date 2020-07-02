defmodule GeoTask.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias GeoTask.Schema.User
  alias GeoTask.Repo

  @roles ["manager", "driver"]

  schema "users" do
    field(:token, :string)
    field(:role, :string)

    has_many(:driver_task, GeoTask.Schema.Task, foreign_key: :driver)
    has_many(:manager_task, GeoTask.Schema.Task, foreign_key: :manager)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:role])
    |> validate_required([:role])
    |> validate_role()
    |> generate_token()
  end

  def find_by_token(token), do: Repo.get_by(__MODULE__, token: token)

  defp generate_token(changeset) do
    changeset |> put_change(:token, Ecto.UUID.generate())
  end

  defp validate_role(changeset) do
    role = get_change(changeset, :role)
    case role in @roles do
      true -> changeset
      false -> add_error(changeset, :role, "role is not in a list")
    end
  end

end
