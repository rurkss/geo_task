defmodule GeoTask.TaskManager do
  alias GeoTask.Schema.{User, Task}
  alias GeoTask.{Repo, Transition}

  def create(params, token) do
    user = User.find_by_token(token)

    with {:ok, status} <- Transition.event(user, nil) do
      %Task{}
      |> Task.changeset(Map.put(params, :status, status), user)
      |> Repo.insert()
    end
  end

  def assign(task_id, token) do
    with :ok <- Task.may_by_assigned?(task_id) do
      update(task_id, token)
    end
  end

  def update(task_id, token) do
    task = Task.find(task_id)
    user = User.find_by_token(token)

    with {:ok, status} <- Transition.event(user, task.status) do
      task
      |> Task.changeset(%{status: status}, user)
      |> Repo.update()
    end
  end
end
