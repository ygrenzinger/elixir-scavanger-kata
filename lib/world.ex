defmodule World do
  use GenServer

  # private(API)

  def init(%{height: height, width: width}) when height < 1 or width < 1 do
    {:error, "width and height should be stricly positive"}
  end

  def init(opts) do
    state = %{
      size: opts
    }

    {:ok, state}
  end

  def handle_call(:get_map, from, state) do
    IO.inspect(from)
    %{width: width, height: height} = state.size

    map =
      Enum.map(1..height, fn _ ->
        Enum.map(1..width, fn _ ->
          :desert
        end)
      end)

    {:reply, {:ok, map}, state}
  end

  # public(API)

  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state)
  end

  def get_map(world) do
    GenServer.call(world, :get_map)
  end
end
