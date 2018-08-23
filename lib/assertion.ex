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
    doc = parse(xml, namespace_conformant: true)

    attrs =
      doc
      |> xmap(
        uid:
          ~x"//saml2p:Response/saml2:Assertion/saml2:Subject/saml2:NameID/text()"s
          |> add_namespace("saml2p", @protocol)
          |> add_namespace("saml2", @assertion),
        attributes: [
          ~x"//saml2p:Response/saml2:Assertion/saml2:AttributeStatement/saml2:Attribute"l
          |> add_namespace("saml2p", @protocol)
          |> add_namespace("saml2", @assertion),
          name: ~x"./@Name"s,
          value: ~x"./saml2:AttributeValue/text()"s |> add_namespace("saml2", @assertion)
        ]
      )

    success =
      doc
      |> xpath(
        ~x"//saml2p:Response/saml2p:Status/saml2p:StatusCode/@Value"s
        |> add_namespace("saml2p", @protocol)
        |> add_namespace("saml2", @assertion)
      ) == @success

    {:ok, timestamp} =
      Timex.parse(
        doc
        |> xpath(
          ~x"//saml2p:Response/saml2:Assertion/saml2:Subject/saml2:SubjectConfirmation/saml2:SubjectConfirmationData/@NotOnOrAfter"s
          |> add_namespace("saml2p", @protocol)
          |> add_namespace("saml2", @assertion)
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
