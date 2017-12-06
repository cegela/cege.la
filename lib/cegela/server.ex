defmodule Cegela.Server do
  @moduledoc """
  Main server/plug module
  """

  @behaviour Plug

  @doc "child spec to let us be supervised"
  def child_spec(opts) do
    Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: __MODULE__,
      options: Keyword.merge(opts, [port: 4001]))
  end

  def init(opts), do: opts

  def call(conn, _opts) do
    import Plug.Conn

    uri =
      %URI{}
      |> Map.put(:scheme, "https")
      |> Map.put(:host, "goo.gl")
      |> Map.put(:path, conn.request_path)
      |> Map.put(:query, conn.query_string)
      |> to_string()

    conn
    |> put_resp_header("Location", uri)
    |> send_resp(302, "")
  end
end
