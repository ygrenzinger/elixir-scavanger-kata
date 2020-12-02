defmodule ScavangerKataTest do
  use ExUnit.Case
  doctest ScavangerKata

  test "As a robot, I want to move on the world to reach a destination" do
    assert ScavangerKata.hello() == :world
  end
end
