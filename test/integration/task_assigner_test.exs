defmodule GeoTask.TaskAssignerTest do
  use ExUnit.Case, async: true

  import GeoTask.Factory
  alias GeoTask.TaskAssigner
  alias GeoTask.Schema.{User, Task}

  setup do
    {:ok, manager: insert!(:manager), driver: insert!(:driver), task: build(:task)}
  end

  describe "create new task by user" do
    test "success: manager", %{manager: user, task: task} do
      {:ok, %Task{status: status, manager: manager}} =
        TaskAssigner.create(%{geopostions: task.geopostions}, user.token)

      assert status == "new"
      assert manager == user
    end

    test "failure: unsupported_transition", %{driver: user, task: task} do
      task = TaskAssigner.create(%{geopostions: task.geopostions}, user.token)

      assert {:error, :unsupported_transition} = task
    end
  end

  describe "assign user to the task" do
    test "success: driver", %{driver: driver, task: task, manager: manager} do
      {:ok, task} = TaskAssigner.create(%{geopostions: task.geopostions}, manager.token)

      {:ok, %Task{status: status, driver: driver}} = TaskAssigner.assign(task.id, driver.token)

      assert status == "assign"
      assert driver == driver
    end

    test "failure: task_already_assigned", %{driver: driver, task: task, manager: manager} do
      {:ok, task} = TaskAssigner.create(%{geopostions: task.geopostions}, manager.token)

      {:ok, task} = TaskAssigner.assign(task.id, driver.token)

      task = TaskAssigner.assign(task.id, driver.token)

      assert {:error, :task_already_assigned} = task
    end
  end

  describe "update status of task" do
    test "success", %{driver: driver, task: task, manager: manager} do
      {:ok, task} = TaskAssigner.create(%{geopostions: task.geopostions}, manager.token)
      {:ok, task} = TaskAssigner.assign(task.id, driver.token)
      {:ok, %Task{status: status, driver: driver}} = TaskAssigner.update(task.id, driver.token)

      assert status == "done"
    end
  end
end
