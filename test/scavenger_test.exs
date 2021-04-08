defmodule ScavengerTest do
  use ExUnit.Case
  doctest Scavenger

  test "greets the world" do
    assert Scavenger.hello() == :world
  end
end
