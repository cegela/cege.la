defmodule Cegela.StaticTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Cegela.Static

  test "redirects to routes ported from goo.gl" do
    url = "http://somewherelse.com"

    conn =
      :get
      |> conn("/krakem")
      |> Static.call(static_routes: %{"/krakem" => url})

    assert [^url] = get_resp_header(conn, "location")
  end

  test "redirects permanently" do
    url = "http://somewherelse.com"

    conn =
      :get
      |> conn("/krakem")
      |> Static.call(static_routes: %{"/krakem" => url})

    assert 301 = conn.status
  end

  test "builds a list of routes ported from goo.gl on init" do
    url = "http://lmgtfy.com/?q=ultima+vers%C3%A3o+do+ubuntu"

    assert [static_routes: %{"/KrAKm" => ^url}] = Static.init([])
  end

  test "does nothing to something that does not match a static" do
    conn = conn(:get, "/krakem")

    assert ^conn = Static.call(conn, static_routes: %{})
  end
end
