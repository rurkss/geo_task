defmodule GeoTask.TaskManager do
  alias GeoTask.Schema.{User, Task}
  alias GeoTask.{Repo, Transition}

  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def assign_in_queue(task_id, token) do
    __MODULE__
      |> GenServer.call({:assign, task_id, token})
  end

  def handle_call({:assign, task_id, token}, _from, state) do
    {:reply, assign(task_id, token), state}
  end

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

  def closest_task(%{long: long, lat: lat} = params), do: Task.get_closest(params)
  def closest_task(_), do: {:error, :invalid_params}
end
