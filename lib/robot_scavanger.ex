defmodule RobotScavanger do
  defstruct position: %{x: 0, y: 0}, orientation: :north

  @doc """
  Create a new Robot

  ## Examples

      iex> RobotScavanger.create_robot()
      %RobotScavanger{position: %{x: 0, y: 0}, orientation: :north}

      iex> RobotScavanger.create_robot(%{x: 1, y: -1}, :south)
      %RobotScavanger{position: %{x: 1, y: -1}, orientation: :south}

  """
  def create_robot(pos \\ %{x: 0, y: 0}, orientation \\ :north)
      when orientation in [:north, :south, :west, :east],
      do: %RobotScavanger{position: pos, orientation: orientation}

  def turn_right(robot = %{orientation: orientation}),
    do: %RobotScavanger{robot | orientation: next_orientation(orientation)}

  defp next_orientation(:north), do: :east
  defp next_orientation(:west), do: :north
  defp next_orientation(:south), do: :west
  defp next_orientation(:east), do: :south

  def turn_left(robot = %{orientation: orientation}),
    do: %RobotScavanger{robot | orientation: previous_orientation(orientation)}

  defp previous_orientation(:north), do: :west
  defp previous_orientation(:west), do: :south
  defp previous_orientation(:south), do: :east
  defp previous_orientation(:east), do: :north

  def move_forward(robot = %{orientation: orientation, position: position}) do
    %RobotScavanger{
      robot
      | position: Map.get(move_forward_by_orientation(), orientation).(position)
    }
  end

  defp move_forward_by_orientation(),
    do: %{
      north: fn pos -> %{pos | y: pos.y + 1} end,
      south: fn pos -> %{pos | y: pos.y - 1} end,
      east: fn pos -> %{pos | x: pos.x + 1} end,
      west: fn pos -> %{pos | x: pos.x - 1} end
    }
end
