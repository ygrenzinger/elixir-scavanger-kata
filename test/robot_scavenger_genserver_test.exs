defmodule RobotScavangerGenserverTest do
  use ExUnit.Case, async: true

  test "create a robot at a position and retrieve its position" do
    {:ok, robot_pid} = start_supervised({RobotScavangerGenserver, %{x: 2, y: -2}})

    assert %{x: 2, y: -2} = RobotScavangerGenserver.position(robot_pid)
  end

  test "create a robot at a position  and with an orientation and make it move" do
    {:ok, robot_pid} = start_supervised({RobotScavangerGenserver, %{x: 2, y: -2}})

    robot_pid
    |> RobotScavangerGenserver.turn_left()
    |> RobotScavangerGenserver.turn_left()
    |> RobotScavangerGenserver.move()

    RobotScavangerGenserver.turn_left(robot_pid)

    assert %{x: 2, y: -3} = RobotScavangerGenserver.position(robot_pid)
  end
end
