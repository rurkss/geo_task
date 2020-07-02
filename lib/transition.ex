defmodule GeoTask.Transition do

  alias GeoTask.Schema.{User, Task}

  def event(%User{role: "driver"} = user, %Task{status: "new"} = task), do: {:ok, %Task{task | status: "assign", driver: user}}

  def event(%User{role: "driver"}, %Task{status: "assign"} = task), do: {:ok, %Task{task | status: "done"}}

  def event(%User{role: "manager"} = user, %Task{status: nil} = task), do: {:ok, %Task{task | status: "new", manager: user}}

  def event(nil, _), do: {:error, :user_not_found}

  def event(_, nil), do: {:error, :task_not_found}

  def event(_, _), do: {:error, :unsupported_transition}
end
