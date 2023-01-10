defmodule CegelaTest do
  use ExUnit.Case, async: true

  alias Cegela.Server

  doctest Cegela

  def get!(url) do
    Req.get!("http://#{url}", plug: Server, follow_redirects: false)
  end

  describe inspect(&Server.call/2) do
    test "redirects to bit.ly" do
      assert {"location", "https://bit.ly/something?query=x"} =
               get!("/something?query=x")
               |> Map.get(:headers)
               |> List.keyfind("location", 0)
    end

    test "redirects permanently" do
      assert get!("/something?query=x").status == 301
    end

    test "there is no favicon" do
      assert get!("/favicon.ico").status == 404
    end
  end
end
