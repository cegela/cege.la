defmodule Cegela.Server do
  @moduledoc """
  Main server/plug module
  """

  use Plug.Router
  use Sentry.PlugCapture

  plug(Plug.RequestId)
  plug(Plug.Logger)
  plug(Sentry.PlugContext)
  plug(Cegela.Static)
  plug(:match)
  plug(:dispatch)

  @doc "child spec to let us be supervised"
  def child_spec(opts) do
    port = Application.get_env(:cegela, __MODULE__)[:port]
    opts = Keyword.merge([scheme: :http, plug: __MODULE__, port: port], opts)

    Bandit.child_spec(opts)
  end

  get "/favicon.ico" do
    send_resp(conn, 404, "not here")
  end

  match _ do
    url = URI.merge("https://bit.ly", "#{conn.request_path}?#{conn.query_string}")

    conn
    |> put_resp_header("location", to_string(url))
    |> send_resp(301, "Moved to #{url}")
  end
end
