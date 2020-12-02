defmodule RobotScavangerGenserver do
    use GenServer


    # Client

    def start_link(pos) do
      GenServer.start_link(__MODULE__, pos)
    end

    def position(pid) do
      GenServer.call(pid, :position)
    end

    def turn_left(pid) do
      GenServer.call(pid, :turn_left)
      pid
    end

    def move(pid) do
      GenServer.call(pid, :move_forward)
      pid
    end

    # Serveur

    def init(args) do
      {:ok, RobotScavanger.createRobot(args)}
    end

    def handle_call(:position, _from, robot) do
      {:reply, robot.position, robot}
    end

    def handle_call(:turn_left, _from, robot) do
      newState = RobotScavanger.turnLeft(robot)
      {:reply, :ok, newState}
    end

    def handle_call(:move_forward, _from, robot) do
      {:reply, :ok, RobotScavanger.moveForward(robot)}
    end
end
