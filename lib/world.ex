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

    def add_robot(world, robot_pid, position) do
        %{x: x, y: y} = position
        updatedField = List.update_at(world.field, y, &updateRow(&1, x, robot_pid))
        %{ world | field: updatedField }
    end

    def robot_move_forward(world, robot_pid) do
        #%{x: x, y: y} = RobotScavangerAgent.get_position(robot_pid)
        %{x: x, y: y} = RobotScavangerAgent.move_forward(robot_pid, get_robot_position(world, robot_pid))
        IO.inspect(%{x: x, y: y})
        field = Enum.map(1..world.height, fn _ -> createRow(world.width) end)
        updatedField = List.update_at(field, y, &updateRow(&1, x, robot_pid))
        
        %{ world | field: updatedField }
    end

    defp get_robot_position(world, robot) do
        flatten = Enum.flat_map(world.field, fn row -> row end)
        i = Enum.find_index(flatten, fn element -> element == robot end)
        IO.inspect({i, world.width, world.height})
        x = rem(i, world.width)
        y = div(i, world.width)
        %{x: x, y: y}
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
