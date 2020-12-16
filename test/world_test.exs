defmodule WorldTest do
  use ExUnit.Case

    
  test "New world is created with a fixed size" do
    world = World.create(2, 3)

    assert World.print(world) == """
    __
    __
    __
    """
  end

  test "Create the simplest world ever" do
    world = World.create(1, 1)

    assert World.print(world) == """
    _
    """
  end

  test "Add robot in the world" do
    world = World.create(2, 2)

    {:ok, world, robot} = World.addRobot(world, 0, 0)

    assert World.print(world) == """
    R_
    __
    """
  end
end
