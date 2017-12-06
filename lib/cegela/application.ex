defmodule Cegela.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Cegela.Server,
    ]

    opts = [strategy: :one_for_one, name: Cegela.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
