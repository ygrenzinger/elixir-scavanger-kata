defmodule WorldAgent do
    alias RobotScavangerAgent
    use Agent

    def start_link(width, height) do
        Agent.start_link(fn -> World.create(width, height) end, name: __MODULE__)
    end

    def create(width, height) do
        start_link(width, height)
    end

    def add_robot(robot_pid, position) do
        Agent.update(__MODULE__, fn world -> World.add_robot(world, robot_pid, position) end)
    end

    def print() do
        Agent.get(__MODULE__, &World.print(&1))
    end

    def robot_move_forward(robot_pid) do
        Agent.update(__MODULE__, &World.robot_move_forward(&1, robot_pid))
    end
end