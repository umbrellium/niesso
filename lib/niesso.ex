defmodule Niesso do
  @moduledoc """
  SAML helper module, intended to make interacting with NIE's SAML endpoint
  from Elixir easier.
  """
  use Private
  alias Niesso.Assertion

  @doc """
  This function takes as input the encoded SAML response received by a SAML
  service provider that is taking part in a SAML flow, and from this we
  validate the data (including ultimately varifying the signature of the
  data), and then we return an instantiated assertion struct containing
  verified information about the user suitable for consumption by the calling
  application.
  """
  def consume_auth_resp(saml_payload) do
    with {:ok, xml} <- decode_saml_payload(saml_payload),
         {:ok, assertion} <- Assertion.from_xml(xml) do
      {:ok, assertion}
    end
  end

  private do
    defp decode_saml_payload(saml_payload) do
      case Base.decode64(saml_payload) do
        {:ok, data} ->
          {:ok, SweetXml.parse(data)}

        _ ->
          {:error, :invalid_payload}
      end
    end
  end
end
