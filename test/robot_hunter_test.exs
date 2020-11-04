defmodule RobotHunterTest do
  use ExUnit.Case
  doctest RobotHunter

  test "New robot by default at x 0 y 0 and orientation towards north" do
    assert RobotHunter.createRobot() == %RobotHunter{position: %{x: 0, y: 0}, orientation: :north}
  end

  test "We're creating a robot in x 1 y -1 and orientation towards south" do
    assert RobotHunter.createRobot(%{x: 1, y: -1}, :south) == %RobotHunter{
             position: %{x: 1, y: -1},
             orientation: :south
           }
  end

  test "We can't create a robot with a camembert orientation" do
    assert_raise FunctionClauseError, fn ->
      RobotHunter.createRobot(%{x: 1, y: -1}, :camembert)
    end
  end

  test "We can turn a robot to left" do
    robot = RobotHunter.createRobot(:north)
            |> RobotHunter.turnLeft
    assert robot.orientation == :west

    robot = RobotHunter.turnLeft(robot)
    assert robot.orientation == :south

    robot = RobotHunter.turnLeft(robot)
    assert robot.orientation == :east

    robot = RobotHunter.turnLeft(robot)
    assert robot.orientation == :north
  end


  test "Can move forward north" do
    robot = RobotHunter.createRobot(%{x: 1, y: 1}, :north)
    |> RobotHunter.moveForward

    assert robot.position.x == 1
    assert robot.position.y == 2
  end

  test "Can move forward twice north" do
    robot = RobotHunter.createRobot(%{x: 1, y: 1}, :north)
    |> RobotHunter.moveForward
    |> RobotHunter.moveForward

    assert robot.position.x == 1
    assert robot.position.y == 3
  end

  test "Can move forward south" do
    robot = RobotHunter.createRobot(%{x: 1, y: 1}, :south)
    |> RobotHunter.moveForward

    assert robot.position.x == 1
    assert robot.position.y == 0
  end
end
