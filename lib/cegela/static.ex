defmodule Cegela.Static do
  @moduledoc """
  Module to hard code shortneds we want to keep from goo.gl
  """

  @behaviour Plug

  import Plug.Conn

  require Logger

  def init(opts) do
    static_routes =
      "lib/static.csv"
      |> File.stream!()
      |> Stream.map(fn line ->
        [id | [uri | _]] = String.split(line, ",")

        Logger.debug(fn ->
          "Mapping #{id} to #{uri}"
        end)

        {"/#{id}", uri}
      end)
      |> Enum.into(%{})

    Keyword.put(opts, :static_routes, static_routes)
  end

  def call(conn, opts) do
    routes = Keyword.get(opts, :static_routes, %{})

    case Map.fetch(routes, conn.request_path) do
      :error ->
        conn

      {:ok, uri} ->
        conn
        |> put_resp_header("Location", uri)
        |> send_resp(302, "")
        |> halt()
    end
  end
end
