defmodule WorldAgent do
  alias RobotScavangerAgent
  use Agent

  def start_link(width, height) do
    Agent.start_link(fn -> World.create(width, height) end, name: __MODULE__)
  end

  def create(width, height) do
    start_link(width, height)
  end

  def add_scrap(scrap_value, position) do
    Agent.update(__MODULE__, &World.add_scrap(&1, scrap_value, position))
  end

  def is_scrap_at(position) do
    Agent.get(__MODULE__, &World.is_scrap_at(&1, position))
  end

  def add_robot(robot_pid, position) do
    Agent.update(__MODULE__, fn world -> World.add_robot(world, robot_pid, position) end)
  end

  def robot_move_forward(robot_pid) do
    Agent.update(__MODULE__, &World.robot_move_forward(&1, robot_pid))
  end

  def get_robot_position(robot_pid) do
    Agent.get(__MODULE__, &World.get_robot_position(&1, robot_pid))
  end

  def get_scrap_positions() do
    Agent.get(__MODULE__, &World.get_scrap_positions(&1))
  end

  def print() do
    Agent.get(__MODULE__, &World.print(&1))
  end
end
