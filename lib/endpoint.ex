defmodule GeoTask.Endpoint do
  @moduledoc """
  A Plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """

  alias GeoTask.TaskManager

  use Plug.Router

  # This module is a Plug, that also implements it's own plug pipeline, below:

  # Using Plug.Logger for logging request information
  plug(Plug.Logger)
  # responsible for matching routes
  plug(:match)
  # Using Poison for JSON decoding
  # Note, order of plugs is important, by placing this _after_ the 'match' plug,
  # we will only parse the request AFTER there is a route match.
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  # responsible for dispatching responses
  plug(:dispatch)

  # A simple route to test that the server is up
  # Note, all routes must return a connection as per the Plug spec.
  post "/closest_pickup" do
    {status, body} =
      case conn.body_params do
        %{"long" => long, "lat" => lat} ->
          response =
            TaskManager.closest_task(%{long: long, lat: lat})

          {200, Poison.encode!(%{status: :ok, data: response})}

        _ ->
          {422, missing_events()}
      end

    send_resp(conn, status, body)
  end

  post "/create_task" do
    {status, body} =
      case conn.body_params do
        %{
          "token" => token,
          "pickup" => %{"long" => long_from, "lat" => lat_from},
          "delivery" => %{"long" => long_to, "lat" => lat_to}
        } ->
          {status, response} =
            TaskManager.create(
              %{
                geopostions: [%{long: long_from, lat: lat_from}, %{long: long_to, lat: lat_to}]
              },
              token
            )

          {200, Poison.encode!(%{status: status, data: response})}

        _ ->
          {422, missing_events()}
      end

    send_resp(conn, status, body)
  end

  post "/assign_driver" do
    {status, body} =
      case conn.body_params do
        %{"token" => token, "task_id" => task_id} ->
          {status, response} = TaskManager.assign_in_queue(task_id, token)
          {200, Poison.encode!(%{status: status, data: response})}

        _ ->
          {422, missing_events()}
      end

    send_resp(conn, status, body)
  end

  post "/deliver" do
    {status, body} =
      case conn.body_params do
        %{"token" => token, "task_id" => task_id} ->
          {status, response} = TaskManager.update(task_id, token)
          {200, Poison.encode!(%{status: status, data: response})}

        _ ->
          {422, missing_events()}
      end

    send_resp(conn, status, body)
  end

  defp missing_events do
    Poison.encode!(%{error: :invalid_params})
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
