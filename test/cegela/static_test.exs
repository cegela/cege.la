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

    assert 302 = conn.status
    assert [^url] = get_resp_header(conn, "location")
  end

  test "builds a list of routes ported from goo.gl on init" do
    url = "http://lmgtfy.com/?q=ultima+vers%C3%A3o+do+ubuntu"

    assert [static_routes: %{"/KrAKm" => ^url}] = Static.init([])
  end
end
