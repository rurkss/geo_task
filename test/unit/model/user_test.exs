defmodule GeoTask.TransitionTest do
  use ExUnit.Case, async: true

  import GeoTask.Factory

  alias GeoTask.Schema.User

  describe "create user" do
    test "validate roles: failure" do
      user = User.changeset(%User{}, %{role: "fake"})

      assert user.valid? == false
    end

    test "validate roles: success for manager" do
      user = User.changeset(%User{}, %{role: "manager"})

      assert user.valid?
    end

    test "validate roles: success for driver" do
      user = User.changeset(%User{}, %{role: "driver"})

      assert user.valid?
    end
  end

end
