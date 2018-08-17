defmodule NiessoTest do
  use ExUnit.Case
  doctest Niesso

  test "consumes a response and returns an assertion" do
    response = "response"
    assert Niesso.consume_response(response) == :assertion
  end
end
