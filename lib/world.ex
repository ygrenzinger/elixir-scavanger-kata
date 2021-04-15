defmodule World do
  use GenServer

  # private(API)

  def init(%{height: height, width: width}) when height < 1 or width < 1 do
    {:error, "width and height should be stricly positive"}
  end

  def init(opts) do
    state = %{
      size: opts,
      locations: %{}
    }

    {:ok, state}
  end

  def handle_call(:get_map, from, state) do
    IO.inspect(from)
    IO.inspect(state)
    %{width: width, height: height} = state.size

    map =
      Enum.map(0..height - 1, fn y ->
        Enum.map(0..width - 1, fn x ->
          Map.get(state.locations, {x, y}, :desert)
        end)
      end)

    {:reply, {:ok, map}, state}
  end

  def handle_call({:add_robot, scavenger_pid, x, y}, from, state) do
    state = %{
      size: state.size,
      locations: %{{x, y} => scavenger_pid}
    }

    {:reply, :ok, state}
  end

  # public(API)

  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state)
  end

  def get_map(world) do
    GenServer.call(world, :get_map)
  end

  def add_robot(world, scavenger_pid, x, y) do
    GenServer.call(world, {:add_robot, scavenger_pid, x, y})
  end
end
