defmodule RobotScavangerAgentTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, robot} = RobotScavangerAgent.start_link(%{x: 2, y: -2})
    WorldAgent.create(5, 5)
    %{robot: robot}
  end

  test "retrieve robot position", %{robot: robot} do
    assert %{x: 2, y: -2} == RobotScavangerAgent.get_position(robot)
  end

  test "make robot turn and move", %{robot: robot} do
    robot
    |> RobotScavangerAgent.turn_right()
    |> RobotScavangerAgent.turn_right()
    |> RobotScavangerAgent.turn_left()
    |> RobotScavangerAgent.move_forward()

    assert %{x: 3, y: -2} == RobotScavangerAgent.get_position(robot)
  end
end
