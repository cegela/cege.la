import Config

if config_env() != :test do
  config :cegela, Cegela.Server, port: System.get_env("PORT", "4000") |> String.to_integer()
end

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  environment_name: config_env(),
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  logs: [
    level: :info,
    excluded_domains: [],
    metadata: []
  ],
  tags: %{
    env: "production"
  }
