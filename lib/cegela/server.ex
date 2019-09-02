defmodule Cegela.Server do
  @moduledoc """
  Main server/plug module
  """

  use Plug.Router

  alias Plug.Adapters.Cowboy

  plug(Plug.RequestId)
  plug(Plug.Logger)
  plug(Cegela.Static)
  plug(:match)
  plug(:dispatch)

  @doc "child spec to let us be supervised"
  def child_spec(opts) do
    port = Application.get_env(:cegela, __MODULE__)[:port]

    Cowboy.child_spec(
      scheme: :http,
      plug: __MODULE__,
      options: Keyword.merge(opts, port: port)
    )
  end

  get "/favicon.ico" do
    send_resp(conn, 404, "not here")
  end

  match _ do
    uri =
      %URI{}
      |> Map.put(:scheme, "https")
      |> Map.put(:host, "bit.ly")
      |> Map.put(:path, conn.request_path)
      |> Map.put(:query, conn.query_string)
      |> to_string()

    conn
    |> put_resp_header("location", uri)
    |> send_resp(302, "")
  end
end
