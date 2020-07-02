defmodule GeoTask.Transition do

  alias GeoTask.Schema.User

  def event(%User{role: "driver"}, "new"), do: {:ok, "assign"}

  def event(%User{role: "driver"}, "assign"), do: {:ok, "done"}

  def event(%User{role: "manager"}, nil), do: {:ok, "new"}

  def event(nil, _), do: {:error, :user_not_found}

  def event(_, _), do: {:error, :unsupported_transition}
end
