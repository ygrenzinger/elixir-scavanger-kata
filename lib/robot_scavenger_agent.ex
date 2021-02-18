defmodule RobotScavangerAgent do
  use Agent

  def start_link(orientation) do
    Agent.start_link(fn -> RobotScavanger.create_robot(orientation) end)
  end

  def create(orientation \\ :north) do
    start_link(orientation)
  end

  def turn_right(robot) do
    Agent.update(robot, &RobotScavanger.turn_right(&1))
    robot
  end

  def turn_left(robot) do
    Agent.update(robot, &RobotScavanger.turn_left(&1))
    robot
  end

  def move_forward(robot, pos) do
    Agent.get(robot, &RobotScavanger.move_forward(&1, pos))
  end

  def get_durability(robot) do
    Agent.get(robot, &RobotScavanger.get_durability(&1))
  end

  def update_durability(robot, scrap) do
    Agent.update(robot, &RobotScavanger.update_durability(&1, scrap))
  end
end
