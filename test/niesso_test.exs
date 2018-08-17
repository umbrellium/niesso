defmodule NiessoTest do
  use ExUnit.Case
  doctest Niesso

  describe "consume_auth_resp/2" do
    test "consumes a response and returns an assertion" do
      response = "response"
      assert Niesso.consume_auth_resp(:undefined, response) == :assertion
    end
  end

  describe "decoding saml payload" do
    @encoded_payload "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHNhbWwycDpSZXNwb25zZT4KPHNhbWwycDpSZXNwb25zZT4="

    test "has method for decoding a saml payload" do
      assert Niesso.decode_saml_payload(:undefined, "foo") == "foo"
    end

    test "returns parsed xml document"do
      
    end
  end
end
