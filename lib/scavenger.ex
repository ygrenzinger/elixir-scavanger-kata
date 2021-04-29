defmodule Scavenger do
  use GenServer

  # private (API)
  def init(opts) do
    state = %{world: opts.world}
    {:ok, state}
  end

  def handle_call({:move, direction}, _from, state) do
    World.move_scavenger(state.world, self(), direction)
    {:reply, :ok, state}
  end

  # public (API)
  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state)
  end

  def move(scavenger, direction) do
    GenServer.call(scavenger, {:move, direction})
  end
end
