defmodule GeoTask.Transition do

  alias GeoTask.Schema.User
  alias GeoTask.Schema.Task

  def event(%User{role: "driver"} = user, %Task{status: "new"} = task), do: %Task{task | status: "assign", driver: user}

  def event(%User{role: "driver"}, %Task{status: "assign"} = task), do: %Task{task | status: "done"}

  def event(%User{role: "manager"} = user, %Task{status: nil} = task), do: %Task{task | status: "new", manager: user}

  def event(nil, _), do: :user_not_found

  def event(_, nil), do: :task_not_found

  def event(_, _), do: :unsupported_transition  
end
