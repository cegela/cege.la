defmodule Cegela.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cegela,
      version: "0.2.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :hackney],
      mod: {Cegela.Application, []}
    ]
  end

  defp releases do
    [
      cegela: [
        include_executables_for: [:unix],
        applications: [cegela: :permanent, runtime_tools: :permanent]
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.8"},
      {:bandit, ">= 0.5.8"},
      {:sentry, "~> 8.0"},
      {:jason, "~> 1.1"},
      {:hackney, "~> 1.8"},
      {:excoveralls, "~> 0.7", only: :test},
      {:sobelow, "~> 0.8", only: :dev},
      {:mix_audit, "~> 2.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:mix_machine, "~> 0.1", only: [:dev]}
    ]
  end
end
