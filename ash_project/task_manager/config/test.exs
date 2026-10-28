import Config
config :task_manager, token_signing_secret: "yr7Pm2ESH4W91ce8RUS6Juo39Psozk+v"
config :bcrypt_elixir, log_rounds: 1
config :ash, disable_async?: true

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :task_manager, TaskManager.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "task_manager_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :task_manager, TaskManagerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "SMDvtfE7WXBT4jMRWCH3n3Uo4T4OjOrldAV7w45osExteFQtAQlJWQqYoG8Lsby3",
  server: false

# In test we don't send emails
config :task_manager, TaskManager.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Sort query params output of verified routes for robust url comparisons
config :phoenix,
  sort_verified_routes_query_params: true
