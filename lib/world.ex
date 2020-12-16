defmodule World do

    def create(width, height) do
        %{width: width, height: height}
    end

    def print(%{width: width, height: height}) do
        Enum.join(Enum.map(1..height, fn _ -> printRow(width) end), "\n")  <> "\n"
    end

    def addRobot(world, x, y) do
        robot = RobotScavangerAgent.create(%{x: x, y: y})
        {:ok, world, robot}
    end

    defp printRow(width) do
        Enum.join(Enum.map(1..width, fn _ -> "_" end))
    end
end