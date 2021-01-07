defmodule World do
    defstruct width: nil, height: nil, field: nil

    def apply_command(world, robot, :move_forward) do
        {:ok, world, robot}
    end

    def create(width, height) do
        field = Enum.map(1..height, fn _ -> createRow(width) end)
        %World{width: width, height: height, field: field}
    end

    defp createRow(width) do
        Enum.map(1..width, fn _ -> :lowland end)
    end

    def add_robot(world, robot_pid) do
        %{x: x, y: y} = RobotScavangerAgent.get_position(robot_pid)
        updatedField = List.update_at(world.field, y, &updateRow(&1, x, robot_pid))
        %{ world | field: updatedField }
    end

    def robot_has_moved(world, robot_pid) do
        %{x: x, y: y} = RobotScavangerAgent.get_position(robot_pid)
        field = Enum.map(1..world.height, fn _ -> createRow(world.width) end)
        updatedField = List.update_at(field, x, &updateRow(&1, y, robot_pid))
        %{ world | field: updatedField }
    end

    defp updateRow(row, x, elmt) do
        List.update_at(row, x, fn _ -> elmt end)
    end

    def print(world) do
        if world.field == nil do
            ""
        else
            Enum.join(Enum.map(world.field, fn row -> printRow(row) end), "\n")  <> "\n"
        end
    end

    defp printRow(row) do
        Enum.join(Enum.map(row, &printSquare(&1)))
    end

    defp printSquare(square) do
        if is_pid(square) do
            "R"
        else
            "_"
        end
    end
end
