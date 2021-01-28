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
    WorldAgent.create(2, 3)
    {_, robot_pid} = RobotScavangerAgent.create()

    WorldAgent.add_robot(robot_pid, %{x: 0, y: 1})

    assert WorldAgent.print() == """
    __
    R_
    __
    """
  end

  test "Move robot in the world" do
    WorldAgent.create(2, 3)
    {_, robot_pid} = RobotScavangerAgent.create()

    WorldAgent.add_robot(robot_pid, %{x: 0, y: 1})

    assert WorldAgent.print() == """
    __
    R_
    __
    """

    WorldAgent.robot_move_forward(robot_pid)

    assert WorldAgent.print() == """
    R_
    __
    __
    """
  end
end
