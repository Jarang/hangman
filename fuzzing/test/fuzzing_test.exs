defmodule FuzzingTest do
  use ExUnit.Case
  doctest Fuzzing

  test "greets the world" do
    assert Fuzzing.hello() == :world
  end
end
