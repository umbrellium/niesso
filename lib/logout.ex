defmodule Niesso.Logout do
  @moduledoc """
  This module exposes a utility method for building a SAML logout request.
  """

  require EEx

  @template """
  <samlp:LogoutRequest
    xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
    xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
    IssueInstant="<%= timestamp %>"
    Destination="<%= destination %>"
    Version="2.0">
    <saml:NameID Format="urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"><%= uid %></saml:NameID>
  </samlp:LogoutRequest>\
  """

  EEx.function_from_string(:def, :build_xml, @template, [:timestamp, :destination, :uid])

  @doc """
  Returns a deflated encoded request suitable for including as an HTTP-Redirect binding parameter for SAML logout requests
  """
  def build_request(uid, destination, options \\ []) do
    timestamp = DateTime.to_iso8601(Keyword.get(options, :timestamp, DateTime.utc_now()))

    xml = build_xml(timestamp, destination, uid)

    xml
    |> :zlib.zip()
    |> Base.encode64()
    |> URI.encode()
  end
end
