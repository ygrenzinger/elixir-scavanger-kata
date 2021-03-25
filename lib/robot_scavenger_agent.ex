defmodule RobotScavangerAgent do
  use Agent

  def start_link(orientation, speed) do
    Agent.start_link(fn -> RobotScavanger.create_robot(orientation, speed) end)
  end

  def create(orientation \\ :north, speed \\ 1) do
    start_link(orientation, speed)
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

  def get_speed(robot) do
    Agent.get(robot, &RobotScavanger.get_speed(&1))
  end

  def update_durability(robot, scrap) do
    Agent.update(robot, &RobotScavanger.update_durability(&1, scrap))
  end

  def search_and_peek(robot) do
    Task.async(fn -> peek(robot) end)
  end

  def peek(robot) do
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

    ## distance formula d = sqrt((x1 - x2)^2 + (y1 - y2)^2)
    scraps = WorldAgent.get_scrap_positions()
    IO.inspect(scraps)
    robot_position = WorldAgent.get_robot_position(robot)
    IO.inspect({robot, robot_position})
    peek(robot, sort(scraps, robot_position))
  end

  defp sort(scraps, robot_position) do    
    Enum.sort(scraps, fn scrap1, scrap2 -> distance(scrap1, robot_position) > distance(scrap2, robot_position) end)
  end

  defp distance(%{x: x1, y: y1}, %{x: x2, y: y2}) do
    :math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
  end

  defp peek(robot, [] = scraps) do
    robot
  end

  defp peek(robot, [scrap|tail] = scraps) do
    %{x: scrap_x, y: scrap_y} = scrap
    %{x: robot_x, y: robot_y} = WorldAgent.get_robot_position(robot)

    robot
    |> turn_to(x_orientation_target(scrap_x, robot_x))
    |> move_forward_times(scrap_x - robot_x)
    |> turn_to(y_orientation_target(scrap_y, robot_y))
    |> move_forward_times(scrap_y - robot_y)

    peek(robot)
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
