defmodule RobotScavangerTest do
  use ExUnit.Case
  doctest RobotScavanger

  test "New robot by default at x 0 y 0 and orientation towards north" do
    assert RobotScavanger.createRobot() == %RobotScavanger{position: %{x: 0, y: 0}, orientation: :north}
  end

  test "We're creating a robot in x 1 y -1 and orientation towards south" do
    assert RobotScavanger.createRobot(%{x: 1, y: -1}, :south) == %RobotScavanger{
             position: %{x: 1, y: -1},
             orientation: :south
           }
  end

  test "We can't create a robot with a camembert orientation" do
    assert_raise FunctionClauseError, fn ->
      RobotScavanger.createRobot(%{x: 1, y: -1}, :camembert)
    end
  end

  test "We can turn a robot to left" do
    robot = RobotScavanger.createRobot(:north)
            |> RobotScavanger.turnLeft
    assert robot.orientation == :west

    robot = RobotScavanger.turnLeft(robot)
    assert robot.orientation == :south

    robot = RobotScavanger.turnLeft(robot)
    assert robot.orientation == :east

    robot = RobotScavanger.turnLeft(robot)
    assert robot.orientation == :north
  end


  test "Can move forward north" do
    robot = RobotScavanger.createRobot(%{x: 1, y: 1}, :north)
    |> RobotScavanger.moveForward

    assert robot.position.x == 1
    assert robot.position.y == 2
  end

  test "Can move forward twice north" do
    robot = RobotScavanger.createRobot(%{x: 1, y: 1}, :north)
    |> RobotScavanger.moveForward
    |> RobotScavanger.moveForward

    assert robot.position.x == 1
    assert robot.position.y == 3
  end

  test "Can move forward south" do
    robot = RobotScavanger.createRobot(%{x: 1, y: 1}, :south)
    |> RobotScavanger.moveForward

    assert robot.position.x == 1
    assert robot.position.y == 0
  end
end
