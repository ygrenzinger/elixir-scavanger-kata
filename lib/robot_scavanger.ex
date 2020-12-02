defmodule RobotScavanger do
  defstruct(position: %{x: 0, y: 0}, orientation: :north)

  @doc """
  Create a new Robot

  ## Examples

      iex> RobotScavanger.createRobot()
      %RobotScavanger{position: %{x: 0, y: 0}, orientation: :north}

      iex> RobotScavanger.createRobot(%{x: 1, y: -1}, :south)
      %RobotScavanger{position: %{x: 1, y: -1}, orientation: :south}

  """
  def createRobot(pos \\ %{x: 0, y: 0}, orientation \\ :north)
      when orientation in [:north, :south, :west, :east],
      do: %RobotScavanger{position: pos, orientation: orientation}

  def turnRight(robot = %{orientation: orientation}),
    do: %RobotScavanger{robot | orientation: nextOrientation(orientation)}

  defp nextOrientation(:north), do: :east
  defp nextOrientation(:west), do: :north
  defp nextOrientation(:south), do: :west
  defp nextOrientation(:east), do: :south

  def turnLeft(robot = %{orientation: orientation}),
    do: %RobotScavanger{robot | orientation: previousOrientation(orientation)}

  defp previousOrientation(:north), do: :west
  defp previousOrientation(:west), do: :south
  defp previousOrientation(:south), do: :east
  defp previousOrientation(:east), do: :north

  defp moveForwardByOrientation(),
    do: %{
      north: fn pos -> %{pos | y: pos.y + 1} end,
      south: fn pos -> %{pos | y: pos.y - 1} end,
      east: fn pos -> %{pos | x: pos.x + 1} end,
      west: fn pos -> %{pos | x: pos.x - 1} end
    }

  def moveForward(robot = %{orientation: orientation, position: position}) do
    %RobotScavanger{robot | position: Map.get(moveForwardByOrientation(), orientation).(position)}
  end
end
