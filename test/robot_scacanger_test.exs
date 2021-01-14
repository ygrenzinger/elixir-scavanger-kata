defmodule RobotScavangerTest do
  use ExUnit.Case
  doctest RobotScavanger

  test "New robot by default at x 0 y 0 and orientation towards north" do
    assert RobotScavanger.create_robot() == %RobotScavanger{
             position: %{x: 0, y: 0},
             orientation: :north
           }
  end

  test "We're creating a robot in x 1 y -1 and orientation towards south" do
    assert RobotScavanger.create_robot(%{x: 1, y: -1}, :south) == %RobotScavanger{
             position: %{x: 1, y: -1},
             orientation: :south
           }
  end

  test "We can't create a robot with a camembert orientation" do
    assert_raise FunctionClauseError, fn ->
      RobotScavanger.create_robot(%{x: 1, y: -1}, :camembert)
    end
  end

  test "We can turn a robot to left" do
    robot =
      RobotScavanger.create_robot(:north)
      |> RobotScavanger.turn_left()

    assert robot.orientation == :west

    robot = RobotScavanger.turn_left(robot)
    assert robot.orientation == :south

    robot = RobotScavanger.turn_left(robot)
    assert robot.orientation == :east

    robot = RobotScavanger.turn_left(robot)
    assert robot.orientation == :north
  end

  test "We can turn a robot to right" do
    robot =
      RobotScavanger.create_robot(:north)
      |> RobotScavanger.turn_right()

    assert robot.orientation == :east

    robot = RobotScavanger.turn_right(robot)
    assert robot.orientation == :south

    robot = RobotScavanger.turn_right(robot)
    assert robot.orientation == :west

    robot = RobotScavanger.turn_right(robot)
    assert robot.orientation == :north
  end

  for {title, departure, orientation, arrival} <- [
        {
          "Can move forward south",
          [x: 1, y: 1],
          "south",
          [x: 1, y: 0]
        },
        {
          "Can move forward north",
          [x: 1, y: 1],
          "north",
          [x: 1, y: 2]
        },
        {
          "Can move forward east",
          [x: 1, y: 1],
          "east",
          [x: 2, y: 1]
        },
        {
          "Can move forward west",
          [x: 1, y: 1],
          "west",
          [x: 0, y: 1]
        }
      ] do
    test "#{title}" do
      robot =
        RobotScavanger.create_robot(
          Enum.into(unquote(departure), %{}),
          String.to_atom(unquote(orientation))
        )
        |> RobotScavanger.move_forward()

      assert Enum.into(unquote(arrival), %{}) == robot.position
    end
  end

  test "Can move forward twice north" do
    robot =
      RobotScavanger.create_robot(%{x: 1, y: 1}, :north)
      |> RobotScavanger.move_forward()
      |> RobotScavanger.move_forward()

    assert robot.position.x == 1
    assert robot.position.y == 3
  end
end
