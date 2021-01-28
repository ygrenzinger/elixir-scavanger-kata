defmodule RobotScavangerAgent do
  use Agent

  def start_link() do
    Agent.start_link(fn -> RobotScavanger.create_robot() end)
  end

  def create() do
    start_link()
  end

  def turn_right(robot) do
    Agent.update(robot, &RobotScavanger.turn_right(&1))
    robot
  end

  def turn_left(robot) do
    Agent.update(robot, &RobotScavanger.turn_left(&1))
    robot
  end
  
  def move_forward(robot_pid, pos) do
    Agent.get(robot_pid, &RobotScavanger.move_forward(&1, pos))
  end
end
