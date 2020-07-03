defmodule GeoTask.Seeds do

  alias GeoTask.Repo
  alias GeoTask.Schema.User

  for _ <- 0..3 do
     Repo.insert! %User{
      role: "driver",
      token: Ecto.UUID.generate()
    }
  end

  Repo.insert! %User{
   role: "manager",
   token: Ecto.UUID.generate()
 }

end
