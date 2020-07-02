defmodule GeoTask.TransitionTest do
  use ExUnit.Case, async: true

  import GeoTask.Factory
  alias GeoTask.Schema.{User, Task}
  alias GeoTask.Transition

  describe "driver transitions" do
    test "allowed change from new to assign" do

      driver = build(:driver)

      result = driver |> Transition.event("new")

      assert {:ok, "assign"} == result
    end

    test "allowed change from assign to done" do

      driver = build(:driver)

      result = driver |> Transition.event("assign")

      assert {:ok, "done"} == result
    end
  end

  describe "manager transitions" do
    test "allowed to create new task" do

      driver = build(:manager)

      result = driver |> Transition.event(nil)

      assert {:ok, "new"} == result
    end
  end

  describe "failed transition" do
    test "forbidden any other transitions" do

      manager = build(:manager)

      result = manager |> Transition.event("assign")

      assert result == {:error, :unsupported_transition}
    end

    test "forbidden to create new task" do

      driver = build(:driver)

      result = driver |> Transition.event(nil)

      assert result == {:error, :unsupported_transition}
    end

    test "user not found" do

      task = build(:task)
      result = nil |> Transition.event("new")

      assert result == {:error, :user_not_found}
    end
  end
end
