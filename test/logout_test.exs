defmodule Niesso.LogoutTest do
  use ExUnit.Case

  alias Niesso.Logout

  describe "building requests" do
    setup do
      timestamp = DateTime.utc_now()

      document = """
      <samlp:LogoutRequest
        xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
        xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
        IssueInstant="#{timestamp |> DateTime.to_iso8601()}"
        Destination="http://example.com"
        Version="2.0">
        <saml:NameID Format="urn:oasis:names:tc:SAML:2.0:nameid-format:persistent">uid</saml:NameID>
      </samlp:LogoutRequest>\
      """

      {:ok, document: document, timestamp: timestamp}
    end

    test "build_xml/3 generates an XML logout request", context do
      timestamp = context[:timestamp] |> DateTime.to_iso8601()

      assert context[:document] == Logout.build_xml(timestamp, "http://example.com", "uid")
    end

    test "build_request/3 generates deflated encoded request with timestamp", context do
      request = Logout.build_request("uid", "http://example.com", timestamp: context[:timestamp])

      decoded_request =
        request
        |> URI.decode()
        |> Base.decode64!()
        |> :zlib.unzip()

      assert context[:document] == decoded_request
    end
  end
end
