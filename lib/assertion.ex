defmodule Niesso.Assertion do
  @moduledoc """
  SAML assertion returned from the IdP upon succesful authentication.
  """
  import SweetXml
  use Timex
  alias Niesso.Assertion

  defstruct uid: "",
            attributes: [],
            success: false,
            expires_at: nil

  @type t :: %__MODULE__{
          uid: String.t(),
          attributes: [map()],
          success: boolean(),
          expires_at: DateTime.t()
        }

  @protocol "urn:oasis:names:tc:SAML:2.0:protocol"
  @assertion "urn:oasis:names:tc:SAML:2.0:assertion"
  @success "urn:oasis:names:tc:SAML:2.0:status:Success"

  @doc """
  This function takes as input raw XML comprising a SAML authorization
  response, and from this data populates and returns an Assertion struct
  containing this data.
  """
  def from_xml(xml) do
    attrs =
      xml
      |> xmap(
        uid: ~x"//saml2p:Response/saml2:Assertion/saml2:Subject/saml2:NameID/text()"s,
        attributes: [
          ~x"//saml2p:Response/saml2:Assertion/saml2:AttributeStatement/saml2:Attribute"l,
          name: ~x"./@Name"s,
          value: ~x"./saml2:AttributeValue/text()"s
        ]
      )

    success =
      xml |> xpath(~x"//saml2p:Response/saml2p:Status/saml2p:StatusCode/@Value"s) == @success

    {:ok, timestamp} =
      Timex.parse(
        xml
        |> xpath(
          ~x"//saml2p:Response/saml2:Assertion/saml2:Subject/saml2:SubjectConfirmation/saml2:SubjectConfirmationData/@NotOnOrAfter"s
        ),
        "{ISO:Extended}"
      )

    attrs =
      Map.merge(attrs, %{
        success: success,
        expires_at: timestamp
      })

    {:ok, struct(Assertion, attrs)}
  end
end
