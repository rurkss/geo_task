defmodule GeoTask.TransitionTest do
  use ExUnit.Case, async: true

  import GeoTask.Factory
  alias GeoTask.Schema.{User, Task}
  alias GeoTask.Transition

  describe "driver transitions" do
    test "allowed change from new to assign" do

      task = build(:task, status: "new")
      driver = build(:driver)

      result = driver |> Transition.event(task)

      assert {:ok, %Task{status: "assign"}} = result
    end

    test "allowed change from assign to done" do

      task = build(:task, status: "assign")
      driver = build(:driver)

      result = driver |> Transition.event(task)

      assert {:ok, %Task{status: "done"}} = result
    end
  end

  describe "manager transitions" do
    test "allowed to create new task" do
      task = build(:task)
      driver = build(:manager)

      result = driver |> Transition.event(task)

      assert {:ok, %Task{manager: manager, status: "new"}} = result
    end
  end

  describe "failed transition" do
    test "forbidden any other transitions" do
      task = build(:task, status: "assign")
      manager = build(:manager)

      result = manager |> Transition.event(task)

      assert result == {:error, :unsupported_transition}
    end

    test "forbidden to create new task" do
      task = build(:task)
      driver = build(:driver)

      result = driver |> Transition.event(task)

      assert result == {:error, :unsupported_transition}
    end

    test "task not found" do
      driver = build(:driver)

      result = driver |> Transition.event(nil)

      assert result == {:error, :task_not_found}
    end

    test "user not found" do

      task = build(:task)
      result = nil |> Transition.event(task)

      assert result == {:error, :user_not_found}
    end
  end
end
