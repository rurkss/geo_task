defmodule GeoTask.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :geo_task, adapter: Ecto.Adapters.Postgres
end
