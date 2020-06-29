defmodule GeoTask.TransitionTest do
  use ExUnit.Case, async: true

  import GeoTask.Factory

  describe "driver transitions" do
    test "allowed change from new to assign" do
    end

    test "allowed change from assign to done" do
    end

    test "forbidden to create new task" do
    end
  end

  describe "manager transitions" do
    test "allowed to create new task" do
    end

    test "forbidden any other transitions" do
    end
  end
end
