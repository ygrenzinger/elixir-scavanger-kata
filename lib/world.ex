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

  def handle_call(:get_map, _from, state) do
    %{width: width, height: height} = state.size

    map =
      Enum.map(0..(height - 1), fn y ->
        Enum.map(0..(width - 1), fn x ->
          Map.get(state.locations, {x, y}, :desert)
        end)
      end)

    {:reply, {:ok, map}, state}
  end

  def handle_call({:add_robot, scavenger_pid, x, y}, _from, state) do
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

  def handle_call({:add_scrap, x, y}, _from, state) do
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

  def handle_call({:move_scavenger, scavenger, :north}, _from, state) do
    handle_move(state, scavenger, fn {x, y} ->
      {x, rem(y - 1 + state.size.height, state.size.height)}
    end)
  end

  def handle_call({:move_scavenger, scavenger, :south}, _from, state) do
    handle_move(state, scavenger, fn {x, y} ->
      {x, rem(y + 1 + state.size.height, state.size.height)}
    end)
  end

  def handle_call({:move_scavenger, scavenger, :east}, _from, state) do
    handle_move(state, scavenger, fn {x, y} ->
      {rem(x + 1 + state.size.width, state.size.width), y}
    end)
  end

  def handle_call({:move_scavenger, scavenger, :west}, _from, state) do
    handle_move(state, scavenger, fn {x, y} ->
      {rem(x - 1 + state.size.width, state.size.width), y}
    end)
  end

  def handle_call(:get_scraps_locations, _from, state) do
    scraps =
      Map.to_list(state.locations)
      |> Enum.filter(fn {_, el} -> el == :scrap end)
      |> Enum.map(fn {coord, _} -> coord end)

    {:reply, scraps, state}
  end

  def handle_call({:get_scavenger_location, scavenger}, _, state) do
    {:reply, get_scavenger_coord(state.locations, scavenger), state}
  end

  defp handle_move(state, scavenger, moveFct) do
    locations = state.locations

    {x, y} = get_scavenger_coord(locations, scavenger)
    newCoord = moveFct.({x, y})

    target = Map.get(locations, newCoord, :desert)

    case target do
      x when is_pid(x) ->
        {:reply, {:error, "can't move there"}, state}

      :scrap ->
        {:reply, {:ok, :scrap}, move_to_new_coord(state, {x, y}, newCoord, scavenger)}

      :desert ->
        {:reply, :ok, move_to_new_coord(state, {x, y}, newCoord, scavenger)}
    end
  end

  defp move_to_new_coord(state, oldCoord, newCoord, scavenger) do
    %{
      state
      | locations:
          state.locations
          |> Map.put(oldCoord, :desert)
          |> Map.put(newCoord, scavenger)
    }
  end

  defp get_scavenger_coord(locations, scavenger) do
    robotToCoord = Map.new(locations, fn {key, val} -> {val, key} end)
    Map.get(robotToCoord, scavenger)
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

  def move_scavenger(world, scavenger, direction) do
    GenServer.call(world, {:move_scavenger, scavenger, direction})
  end

  def get_scraps_locations(world) do
    GenServer.call(world, :get_scraps_locations)
  end

  def get_scavenger_location(world, scavenger) do
    GenServer.call(world, {:get_scavenger_location, scavenger})
  end
end
