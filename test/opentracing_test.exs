defmodule OpentracingTest do
  use ExUnit.Case
  doctest Opentracing

  test "greets the world" do
    assert Opentracing.hello() == :world
  end
end
