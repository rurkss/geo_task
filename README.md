# GeoTask

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `geo_task` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:geo_task, "~> 0.1.0"}
  ]
end
```


```
curl --request POST \
  --url http://127.0.0.1:4001/create_task \
  --header 'content-type: application/json' \
  --data '{
	"token": "91d6262e-183f-4337-9cf8-c48b2eced521",
	"pickup": {
		"long": 30.73262,
		"lat": 46.47747
	},
	"delivery": {
		"long": 24.02324,
		"lat": 49.83826
	}
}'
```

```
curl --request POST \
  --url http://127.0.0.1:4001/closest_delivery \
  --header 'content-type: application/json' \
  --data '{
	"long": 24.031111,
	"lat": 49.842957
}'
```

```
curl --request POST \
  --url http://127.0.0.1:4001/assign_driver \
  --header 'content-type: application/json' \
  --data '{
	"token": "24ebbdf1-d2c7-40f7-911b-ac73cca1ffa6",
	"task_id": 10
}'
```

```
 curl --request POST \
  --url http://127.0.0.1:4001/deliver \
  --header 'content-type: application/json' \
  --data '{
	"token": "24ebbdf1-d2c7-40f7-911b-ac73cca1ffa6"
}'
 ```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/geo_task](https://hexdocs.pm/geo_task).
