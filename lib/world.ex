defmodule World do
  defstruct width: nil, height: nil, robots: %{}, scraps: %{}

  def apply_command(world, robot, :move_forward) do
    {:ok, world, robot}
  end

  def create(width, height) do
    %World{width: width, height: height}
  end

  def add_scrap(world, scrap, position) do
    %{world | scraps: Map.put(world.scraps, position, scrap)}
  end

  def add_robot(world, robot_pid, position) do
    %{world | robots: Map.put(world.robots, robot_pid, position)}
  end

  def robot_move_forward(world, robot_pid) do
    robot_position = world.robots[robot_pid]
    new_position = RobotScavangerAgent.move_forward(robot_pid, robot_position)
    new_position = donut(world, new_position)

    if can_robot_move(world, new_position) do
      %{
        grab_scraps_if_any(world, new_position, robot_pid)
        | robots: Map.put(world.robots, robot_pid, new_position)
      }
    else
      world
    end
  end

  defp donut(world, position) do
    %{
      position
      | y: rem(position.y + world.height, world.height),
        x: rem(position.x + world.width, world.width)
    }
  end

  defp can_robot_move(world, position) do
    !Enum.member?(Map.values(world.robots), position)
  end

  defp grab_scraps_if_any(world, position, robot_pid) do
    scrap_value = world.scraps[position]

    if scrap_value != nil do
      RobotScavangerAgent.update_durability(robot_pid, scrap_value)
      %{world | scraps: Map.delete(world.scraps, position)}
    else
      world
    end
  end

  def print(world) do
    Enum.join(Enum.map(0..(world.height - 1), &printRow(&1, world)), "\n") <> "\n"
  end

  defp printRow(y, world) do
    Enum.join(Enum.map(0..(world.width - 1), &printSquare(&1, y, world)))
  end

  defp printSquare(x, y, world) do
    if Enum.member?(Map.values(world.robots), %{x: x, y: y}) do
      "R"
    else
      "_"
    end
  end
end
