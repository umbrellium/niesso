defmodule Niesso do
  @moduledoc """
  SAML helper module, intended to make interacting with NIE's SAML endpoint
  from Elixir easier.
  """

  alias Niesso.Assertion

  @doc """
  This function takes as input the encoded SAML response received by a SAML
  service provider that is taking part in a SAML flow, and from this we
  validate the data (including ultimately verifying the signature of the
  data), and then we return an instantiated assertion struct containing
  verified information about the user suitable for consumption by the calling
  application.
  """
  @spec consume_auth_resp(String.t()) :: {:ok, Assertion.t()} | {:error, String.t()}
  def consume_auth_resp(raw_payload) do
    with {:ok, xml} <- decode_saml_payload(raw_payload),
         {:ok, assertion} <- Assertion.from_xml(xml) do
      validate_assertion(assertion)
    end
  end

  @spec decode_saml_payload(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  defp decode_saml_payload(saml_payload) do
    case Base.decode64(saml_payload) do
      {:ok, data} ->
        {:ok, data}

      _ ->
        {:error, "Invalid base64 payload"}
    end
  end

  @spec validate_assertion(Assertion.t()) :: {:ok, Assertion.t()} | {:error, String.t()}
  defp validate_assertion(assertion) do
    with {:ok, assertion} <- validate_date(assertion) do
      {:ok, assertion}
    end
  end

  @spec validate_date(Assertion.t()) :: {:ok, Assertion.t()} | {:error, String.t()}
  defp validate_date(assertion) do
    if Timex.before?(Timex.now(), assertion.expires_at) do
      {:ok, assertion}
    else
      {:error, "Attributes have expired"}
    end
  end
end
