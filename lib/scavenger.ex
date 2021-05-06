defmodule Scavenger do
  use GenServer

  # private (API)
  def init(opts) do
    state = %{world: opts.world, durability: 10}
    {:ok, state}
  end

  def handle_call({:move, direction}, _from, state) do
    response = World.move_scavenger(state.world, self(), direction)
    handle_move_response(state, response)
  end

  defp handle_move_response(state, {:ok, :scrap}) do
    {:reply, :ok, %{ state | durability: state.durability + 10 }}
  end

  defp handle_move_response(state, response) do
    {:reply, response, state}
  end

  def handle_call(:get_durability, _from, state) do
    {:reply, state.durability, state}
  end

  # public (API)
  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state)
  end

  def move(scavenger, direction) do
    GenServer.call(scavenger, {:move, direction})
  end

  def get_durability(scavenger) do
    GenServer.call(scavenger, :get_durability)
  end
end
