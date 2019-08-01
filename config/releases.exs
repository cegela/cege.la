import Config

config :cegela, Cegela.Server, port: System.get_env("PORT") |> Integer.parse() |> elem(0)
