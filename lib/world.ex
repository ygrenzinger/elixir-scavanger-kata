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
    if Map.has_key?(state.locations, {x, y}) do
      {:reply, {:error, "you should call Elon and explain why you loose 100M DOGE. "}, state}
    else
      state = %{
        size: state.size,
        locations: Map.put(state.locations, {x, y}, scavenger_pid)
      }
      {:reply, :ok, state}
    end
  end

  def handle_call({:add_scrap, x, y}, from, state) do
    if Map.has_key?(state.locations, {x, y}) do
      {:reply, {:error, "There is already something here"}, state}
    else
      state = %{
        size: state.size,
        locations: Map.put(state.locations, {x, y}, :scrap)
      }
      {:reply, :ok, state}
    end
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

  def add_scrap(world, x, y) do
    GenServer.call(world, {:add_scrap, x, y})
  end
end
