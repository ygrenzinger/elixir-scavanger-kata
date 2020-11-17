defmodule ScavangerKataTest do
  use ExUnit.Case
  doctest ScavangerKata

  test "greets the world" do
    assert ScavangerKata.hello() == :world
  end
end
