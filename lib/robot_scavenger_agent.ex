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

  def do_stuff(robot) do
    # %{x: scrap_x, y: scrap_y} = WorldAgent.get_scrap_positions() |> List.first()
    # %{x: robot_x, y: robot_y} = WorldAgent.get_robot_position(robot)

    # robot
    # |> turn_to(x_orientation_target(scrap_x, robot_x))
    # |> move_forward_times(scrap_x - robot_x)
    # |> turn_to(y_orientation_target(scrap_y, robot_y))
    # |> move_forward_times(scrap_y - robot_y)

    # if Enum.empty?(WorldAgent.get_scrap_positions()) do
    #   robot
    # else
    #   do_stuff(robot)
    # end

    do_stuff(robot, WorldAgent.get_scrap_positions())
  end

  defp do_stuff(robot, [] = scraps) do
    robot
  end

  defp do_stuff(robot, [scrap|tail] = scraps) do
    %{x: scrap_x, y: scrap_y} = scrap
    %{x: robot_x, y: robot_y} = WorldAgent.get_robot_position(robot)

    robot
    |> turn_to(x_orientation_target(scrap_x, robot_x))
    |> move_forward_times(scrap_x - robot_x)
    |> turn_to(y_orientation_target(scrap_y, robot_y))
    |> move_forward_times(scrap_y - robot_y)

    do_stuff(robot, WorldAgent.get_scrap_positions())
  end

  defp x_orientation_target(scrap_x, robot_x) do
    if scrap_x > robot_x do 
      :east
    else
      :west
    end
  end

  defp y_orientation_target(scrap_y, robot_y) do
    if scrap_y > robot_y do 
      :south
    else
      :north
    end
  end

  defp turn_to(robot, orientation) do
    currentOrientation = get_orientation(robot)
    if currentOrientation != orientation do 
      robot
      |> turn_left()
      |> turn_to(orientation)
    else
      robot
    end
  end

  defp get_orientation(robot) do
    Agent.get(robot, &RobotScavanger.get_orientation(&1))
  end

  defp move_forward_times(robot, times) do 
    Enum.each(0..abs(times) - 1, fn _ -> 
      WorldAgent.robot_move_forward(robot)
    end)
    robot
  end

end
