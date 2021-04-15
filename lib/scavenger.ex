defmodule Scavenger do
  use GenServer

  # private (API)

  def init(_opts) do
    state = %{}
    {:ok, state}
  end

  # public (API)

  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state)
  end
end
