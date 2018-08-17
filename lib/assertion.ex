defmodule Niesso.Assertion do
  @moduledoc """
  SAML assertion returned from the IdP upon succesful authentication.
  """
  alias Niesso.Assertion

  defstruct version: "2.0",
            issuer: ""

  @type t :: %__MODULE__{
          version: String.t(),
          issuer: String.t()
        }

  def from_xml(xml) do
    {:ok, %Assertion{}}
  end
end
