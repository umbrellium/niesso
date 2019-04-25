defmodule Niesso.LogoutTest do
  use ExUnit.Case

  describe "building requests" do
    setup do
      document =
        "<samlp:LogoutRequest\n  xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\"\n  xmlns:saml=\"urn:oasis:names:tc:SAML:2.0:assertion\"\n  IssueInstant=\"foo\"\n  Destination=\"bar\"\n  Version=\"2.0\">\n  <saml:NameID Format=\"urn:oasis:names:tc:SAML:2.0:nameid-format:persistent\">baz</saml:NameID>\n</samlp:LogoutRequest>"

      {:ok, document: document}
    end

    test "build_xml/3 generates an XML logout request", context do
      assert context[:document] == Niesso.Logout.build_xml("foo", "bar", "baz")
    end

    test "build_request/3 generates deflated encoded request", context do
      request = Niesso.Logout.build_request("foo", "bar", "baz")
      assert context[:document] == request |> URI.decode() |> Base.decode64!() |> :zlib.unzip()
    end
  end
end
