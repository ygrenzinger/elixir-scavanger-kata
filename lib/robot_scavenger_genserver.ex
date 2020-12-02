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
    GenServer.cast(pid, :turn_left)
    pid
  end

  def move(pid) do
    GenServer.cast(pid, :move_forward)
    pid
  end

  # Serveur

  def init(args) do
    {:ok, RobotScavanger.createRobot(args)}
  end

  def handle_call(:position, _from, robot) do
    {:reply, robot.position, robot}
  end

  def handle_cast(:turn_left, robot) do
    Process.sleep(500)
    newState = RobotScavanger.turnLeft(robot)
    {:noreply, newState}
  end

  def handle_cast(:move_forward, robot) do
    Process.sleep(250)
    {:noreply, RobotScavanger.moveForward(robot)}
  end
end
