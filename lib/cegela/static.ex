defmodule Cegela.Static do
  @moduledoc """
  Module to hard code shortneds we want to keep from goo.gl
  """

  @behaviour Plug

  import Plug.Conn

  require Logger

  @impl true
  def init(opts) do
    static_routes =
      "lib/static.csv"
      |> File.stream!()
      |> Stream.map(fn line ->
        [id, uri | _] = String.split(line, ",")

        Logger.debug("Mapping #{id} to #{uri}")

        {"/#{id}", uri}
      end)
      |> Enum.into(%{})

    Keyword.put(opts, :static_routes, static_routes)
  end

  @impl true
  def call(%Plug.Conn{} = conn, opts) do
    with routes <- Keyword.get(opts, :static_routes, %{}),
         {:ok, uri} <- Map.fetch(routes, conn.request_path) do
      conn
      |> put_resp_header("location", uri)
      |> send_resp(301, "")
      |> halt()
      |> tap(&log/1)
    else
      _ -> conn
    end
  end

  defp log(%Plug.Conn{} = conn) do
    ua = conn.req_headers |> Enum.filter(&match?({"user-agent", _}, &1)) |> Enum.map(&elem(&1, 1))
    ref = conn.req_headers |> Enum.filter(&match?({"referer", _}, &1)) |> Enum.map(&elem(&1, 1))
    remote_ip = conn.remote_ip |> Tuple.to_list()

    x_forwarded_for =
      conn.req_headers
      |> Enum.filter(&match?({"x-forwarded-for", _}, &1))
      |> Enum.map(&elem(&1, 1))

    Logger.info(%{
      static: conn.request_path,
      remote_ip: remote_ip,
      x_forwarded_for: x_forwarded_for,
      ua: ua,
      ref: ref
    })
  end
end
