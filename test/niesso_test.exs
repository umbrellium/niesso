defmodule NiessoTest do
  use ExUnit.Case
  use Timex
  doctest Niesso

  describe "consume_auth_resp/2" do
    setup [:load_valid_authn_resp]

    test "consumes a response and returns an assertion", %{
      response: response,
      timestamp: timestamp
    } do
      assert {:ok, assertion} = Niesso.consume_auth_resp(response)

      assert assertion == %Niesso.Assertion{
               uid: "chan_yau_chun",
               attributes: [
                 %{name: "Email", value: "chan_yau_chun@g.nie.edu.sg"},
                 %{name: "Domain", value: "STD"},
                 %{name: "Name", value: "chan_yau_chun"}
               ],
               success: true,
               expires_at: timestamp
             }
    end

    test "returns error tuple on invalid response" do
      assert {:error, "Invalid base64 payload"} = Niesso.consume_auth_resp("hello world")
    end
  end

  describe "consume_auth_resp/2 with expired payload" do
    setup [:load_expired_authn_resp]

    test "returns an error tuple if stale request", %{response: response} do
      assert {:error, "Attributes have expired"} = Niesso.consume_auth_resp(response)
    end
  end

  defp load_valid_authn_resp(_context) do
    timestamp = Timex.now() |> Timex.shift(minutes: 1) |> DateTime.truncate(:millisecond)

    {:ok, response: encoded_resp(timestamp), timestamp: timestamp}
  end

  defp load_expired_authn_resp(_context) do
    timestamp = Timex.now() |> Timex.shift(minutes: -6) |> DateTime.truncate(:millisecond)

    {:ok, response: encoded_resp(timestamp), timestamp: timestamp}
  end

  defp encoded_resp(timestamp) do
    {:ok, xml} = File.read("test/fixtures/saml_response.xml.eex")

    xml
    |> EEx.eval_string(expires_at: DateTime.to_iso8601(timestamp))
    |> Base.encode64()
  end
end
