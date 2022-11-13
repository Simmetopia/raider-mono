import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :letsraid, LetsRaid.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "letsraid_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :letsraid, LetsRaidWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "tg+0R7Eit2/WzDg/Va/QPHeENKULt7l7kIqQlMcS0N3B0rB+eDfsOdkoG1IAY0y2",
  server: false

# In test we don't send emails.
config :letsraid, LetsRaid.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
