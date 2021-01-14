defmodule WorldTest do
  use ExUnit.Case


  test "New world is created with a fixed size" do
    WorldAgent.create(2, 3)

    assert WorldAgent.print() == """
    __
    __
    __
    """
  end

  test "Create the simplest world ever" do
    WorldAgent.create(1, 1)

    assert WorldAgent.print() == """
    _
    """
  end

  test "Add robot in the world" do
    WorldAgent.create(2, 2)
    {_, robot_pid} = RobotScavangerAgent.create(%{x: 0, y: 0})

    WorldAgent.add_robot(robot_pid)

    assert WorldAgent.print() == """
    R_
    __
    """
  end

  test "Move robot in the world" do
    WorldAgent.create(2, 2)
    {_, robot_pid} = RobotScavangerAgent.create(%{x: 0, y: 0})

    WorldAgent.add_robot(robot_pid)

    WorldAgent.robot_move_forward(robot_pid)

    assert WorldAgent.print() == """
    _R
    __
    """
  end
end
