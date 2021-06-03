defmodule Scavenger do
  use GenServer

  # private (API)
  def init(opts) do
    state = %{world: opts.world, durability: 10}
    {:ok, state}
  end

  def handle_call({:move, direction}, _from, state) do
    response = World.move_scavenger(state.world, self(), direction)
    {:reply, build_move_response(response), update_state(state, response)}
  end

  def handle_call(:move_to_scrap, _from, state) do
    scraps = World.get_scraps_locations(state.world)

    scrap_coord = Enum.at(scraps, 0)

    state = move_to(scrap_coord, state)

    {:reply, :ok, state}
  end

  def handle_call(:gather_scraps, _from, original_state) do
    new_state = scraps(original_state)
    |> Stream.take_while(&(&1 != nil))
    |> Enum.reduce(original_state, &move_to(&1, &2))
    {:reply, :ok, new_state}
  end

  def handle_call(:get_durability, _from, state) do
    {:reply, state.durability, state}
  end

  defp update_state(state, {:ok, :scrap}) do
    %{state | durability: state.durability + 10}
  end

  defp update_state(state, response) do
    state
  end

  defp build_move_response({:ok, :scrap}) do
    :ok
  end

  defp build_move_response(response) do
     response
  end

  defp get_path_between_coords({start_x, start_y}, {end_x, end_y}) do
    diff_x = start_x - end_x
    diff_y = start_y - end_y

    directions = []

    directions = directions ++ cond do
      diff_y > 0 -> Enum.map(1..abs(diff_y), fn _ -> :north end)
      diff_y < 0 -> Enum.map(1..abs(diff_y), fn _ -> :south end)
      true -> []
    end

    directions = directions ++ cond do
      diff_x > 0 -> Enum.map(1..abs(diff_x), fn _ -> :west end)
      diff_x < 0 -> Enum.map(1..abs(diff_x), fn _ -> :east end)
      true -> []
    end

    directions
  end

  defp move_to(coord, state) do
    scavenger_coord = World.get_scavenger_location(state.world, self())

    commands = get_path_between_coords(scavenger_coord, coord)

    Enum.reduce(commands, state, fn command, state ->
      response = World.move_scavenger(state.world, self(), command)
      update_state(state, response)
    end)
  end

  defp scraps(state) do
    Stream.repeatedly(fn  -> 
      case World.get_scraps_locations(state.world) do
        [head|_] -> head
        [] -> nil
      end
    end)
  end

  # public (API)
  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state)
  end

  def move(scavenger, direction) do
    GenServer.call(scavenger, {:move, direction})
  end

  def move_to_scrap(scavenger) do
    GenServer.call(scavenger, :move_to_scrap)
  end

  def gather_scraps(scavenger) do
    GenServer.call(scavenger, :gather_scraps)
  end

  def get_durability(scavenger) do
    GenServer.call(scavenger, :get_durability)
  end
end
