use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_down, PhoenixDown.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix_down, PhoenixDown.Repo,
  adapter: Mongo.Ecto,
  database: "phoenix_down_test",
  pool_size: 1
