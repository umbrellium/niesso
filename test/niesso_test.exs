defmodule NiessoTest do
  use ExUnit.Case
  doctest Niesso

  describe "consume_auth_resp/2" do
    test "consumes a response and returns an assertion" do
      response = "response"
      assert Niesso.consume_auth_resp(response) == :assertion
    end
  end

  describe "decoding saml payload" do
    @encoded_payload "PHNhbWwycDpSZXNwb25zZT48L3NhbWwycDpSZXNwb25zZT4="

    test "returns error if passed invalid payload" do
      assert {:error, :invalid_payload} = Niesso.decode_saml_payload("foo")
    end

    test "returns parsed xml document" do
      assert {:ok, _xml} = Niesso.decode_saml_payload(@encoded_payload)
    end
  end
end
