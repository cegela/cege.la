import Config

config :cegela, Cegela.Server, port: System.get_env("PORT", "4000") |> String.to_integer()

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [:prod]
