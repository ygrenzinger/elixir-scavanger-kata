defmodule RobotScavangerAgent do
  use Agent

  def start_link(pos) do
    Agent.start_link(fn -> RobotScavanger.create_robot(pos) end)
  end

  def create(pos) do
    start_link(pos)
  end

  def get_position(robot) do
    Agent.get(robot, fn robot -> robot.position end)
  end

  def turn_right(robot) do
    Agent.update(robot, &RobotScavanger.turn_right(&1))
    robot
  end

  def turn_left(robot) do
    Agent.update(robot, &RobotScavanger.turn_left(&1))
    robot
  end

  def move_forward(robot) do
    Agent.update(robot, &RobotScavanger.move_forward(&1))
    WorldAgent.robot_has_moved(robot)
    robot
  end

  def move_forward(robot, pos) do
    Agent.update(robot, &RobotScavanger.move_forward(&1, pos))
  end
end
