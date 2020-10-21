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
end
