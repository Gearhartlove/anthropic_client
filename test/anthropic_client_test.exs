defmodule AnthropicClientTest do
  use ExUnit.Case
  doctest AnthropicClient

  test "greets the world" do
    assert AnthropicClient.hello() == :world
  end
end
