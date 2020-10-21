defmodule RobotHunterTest do
  use ExUnit.Case
  doctest RobotHunter

  
  test "New robot by default at x 0 y 0 and orientation towards north" do
    assert RobotHunter.createRobot() == %RobotHunter{position: %{x: 0, y: 0}, orientation: :north}  
  end

  test "We're creating a robot in x 1 y -1 and orientation towards south" do
    assert RobotHunter.createRobot(%{x: 1, y: -1}, :south) == %RobotHunter{position: %{x: 1, y: -1}, orientation: :south}  
  end

  test "We can't create a robot with a camembert orientation" do
    assert_raise ArgumentError, RobotHunter.createRobot(%{x: 1, y: -1}, :camembert)
  end
end
