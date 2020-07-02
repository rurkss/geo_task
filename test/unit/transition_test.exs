defmodule GeoTask.TransitionTest do
  use ExUnit.Case, async: true

  import GeoTask.Factory
  alias GeoTask.Schema.{User, Task, Transition}

  describe "driver transitions" do
    test "allowed change from new to assign" do

      task = build(:task, status: "new")
      driver = build(:driver)

      result = driver |> Transition.event(task)

      assert %Task{driver: driver, status: "assign"} = result
    end

    test "allowed change from assign to done" do

      task = build(:task, status: "assign")
      driver = build(:driver)

      result = driver |> Transition.event(task)

      assert %Task{status: "done"} = result
    end
  end

  describe "manager transitions" do
    test "allowed to create new task" do
      task = build(:task)
      driver = build(:manager)

      result = driver |> Transition.event(task)

      assert %Task{manager: manager, status: "new"} = result
    end
  end

  describe "failed transition" do
    test "forbidden any other transitions" do
      task = build(:task, status: "assign")
      manager = build(:manager)

      result = manager |> Transition.event(task)

      assert result == :unsupported_transition
    end

    test "forbidden to create new task" do
      task = build(:task)
      driver = build(:driver)

      result = driver |> Transition.event(task)

      assert result == :unsupported_transition
    end

    test "task not found" do
      driver = build(:driver)

      result = driver |> Transition.event(nil)

      assert result == :task_not_found
    end

    test "user not found" do

      task = build(:task)
      result = nil |> Transition.event(task)

      assert result == :user_not_found
    end
  end
end
