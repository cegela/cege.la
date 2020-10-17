import Config

config :cegela, Cegela.Server, port: System.get_env("PORT", "4000") |> String.to_integer()
