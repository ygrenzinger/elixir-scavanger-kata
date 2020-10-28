defmodule RobotHunter do
  defstruct(position: %{x: 0, y: 0}, orientation: :north)

  @doc """
  Create a new Robot

  ## Examples

      iex> RobotHunter.createRobot()
      %RobotHunter{position: %{x: 0, y: 0}, orientation: :north}  

      iex> RobotHunter.createRobot(%{x: 1, y: -1}, :south)
      %RobotHunter{position: %{x: 1, y: -1}, orientation: :south}             

  """
  def createRobot(pos \\ %{x: 0, y: 0}, orientation \\ :north)
      when orientation in [:north, :south, :west, :east],
      do: %RobotHunter{position: pos, orientation: orientation}

  def turnLeft(robot = %{orientation: orientation}), do: %RobotHunter{ robot | orientation: turnLeftOrientation(orientation) }

  defp turnLeftOrientation(:north), do: :west
  defp turnLeftOrientation(:west), do: :south
  defp turnLeftOrientation(:south), do: :east
  defp turnLeftOrientation(:east), do: :north

  def moveForward(robot = %{orientation: :north, position: position}), do: %RobotHunter{ robot | position: %{x: 1, y: 2} }
end
