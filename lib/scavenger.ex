defmodule Scavenger do
  use GenServer

  # private (API)
  def init(opts) do
    state = %{world: opts.world, durability: 10}
    {:ok, state}
  end

  def handle_call({:move, direction}, _from, state) do
    response = World.move_scavenger(state.world, self(), direction)
    response = translate_response(response)
    {:reply, response, handle_move_response(state, response)}
  end

  def handle_call(:move_to_scrap, _from, state) do
    scraps = World.get_scraps_locations(state.world)

    scrap_coord = Enum.at(scraps, 0)

    scavenger_coord = World.get_scavenger_location(state.world, self())

    commands = get_path_between_coords(scavenger_coord, scrap_coord)

    Enum.each(commands, fn command ->
      response = World.move_scavenger(state.world, self(), command)
      state = handle_move_response(state, response)
    end)

    {:reply, :ok, state}
  end

  def handle_call(:get_durability, _from, state) do
    {:reply, state.durability, state}
  end

  defp handle_move_response(state, {:ok, :scrap}) do
    %{state | durability: state.durability + 10}
  end

  defp handle_move_response(state, response) do
    state
  end

  defp get_path_between_coords({start_x, start_y}, {end_x, end_y}) do
    diff_x = start_x - end_x
    diff_y = start_y - end_y

    directions = []

    if diff_y > 0 do
      directions = directions ++ Enum.each(1..diff_y, fn _ -> :south end)
    end

    if diff_y < 0 do
      directions = directions ++ Enum.each(1..abs(diff_y), fn _ -> :north end)
    end

    directions
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

  def get_durability(scavenger) do
    GenServer.call(scavenger, :get_durability)
  end
end
