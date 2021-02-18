defmodule TestReverse do
    use ExUnit.Case
    use Quixir


    test "Robot is on the world" do
        ptest x: int(min: 0, max: 2),
            y: int(min: 0, max: 2),
            orientation: choose(from: [value(:north), value(:south), value(:east), value(:west)]),
            commands: list(choose(from: [value(:move_forward), value(:turn_left), value(:turn_right)])) do

            WorldAgent.create(3, 3)
            {_, robot_pid} = RobotScavangerAgent.create(orientation)
            WorldAgent.add_robot(robot_pid, %{x: x, y: y})

            Enum.each(commands, fn(command) ->
                case command do
                   :move_forward -> WorldAgent.robot_move_forward(robot_pid)
                   :turn_left -> RobotScavangerAgent.turn_left(robot_pid)
                   :turn_right -> RobotScavangerAgent.turn_right(robot_pid)
                end
            end)

            assert String.contains?(WorldAgent.print(), "R")

            Agent.stop(WorldAgent)
        end
    end
  end
