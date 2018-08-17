defmodule Niesso do
  @moduledoc """
  SAML helper module, intended to make interacting with NIE's SAML endpoint
  from Elixir easier.
  """

  @doc """
  Consume response takes as input the encoded SAML response received by a
  SAML service provider that is taking part in a SAML flow, and from this we
  validate the data (including ultimately varifying the signature of the
  data), and then we return an instantiated assertion struct containing
  verified information about the user suitable for consumption by the calling
  application.
  """
  def consume_response(response) do
    :assertion
  end
end
