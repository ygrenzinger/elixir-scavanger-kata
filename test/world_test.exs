defmodule WorldTest do
  use ExUnit.Case

  setup do
    size = %{height: 3, width: 3}
    {:ok, world} = World.start_link(size)
    {:ok, world: world}
  end

  test "should create world as a process", state do
    assert(is_pid(state.world))
  end

  test "should create world full of :desert of 3x3", state do
    {:ok, map} = World.get_map(state.world)

    assert(
      map ==
        [
          [:desert, :desert, :desert],
          [:desert, :desert, :desert],
          [:desert, :desert, :desert]
        ]
    )
  end

  test "should fail if init param is wrong" do
    size = %{height: 0, width: -1}
    {:error, msg} = World.start_link(size)
  end

  test "add a robot", state do
    {:ok, scavenger_pid} = Scavenger.start_link()
    World.add_robot(state.world, scavenger_pid, 0, 0)

    {:ok, map} = World.get_map(state.world)
    assert(
      map ==
      [
        [scavenger_pid, :desert, :desert],
        [:desert, :desert, :desert],
        [:desert, :desert, :desert]
      ]
    )
  end

  test "add a second robot to the same place", state do

    {:ok, scavenger_pid} = Scavenger.start_link()
    {:ok, scavenger_pid2} = Scavenger.start_link()
    World.add_robot(state.world, scavenger_pid, 0, 0)

    result = World.add_robot(state.world, scavenger_pid2, 0, 0)

    assert(
      result ==
      {:error, "you should call Elon and explain why you loose 100M DOGE. "}
    )
  end

  test "add a second robot not to the same place of the first one", state do
    {:ok, scavenger_pid} = Scavenger.start_link()
    {:ok, scavenger_pid2} = Scavenger.start_link()
    World.add_robot(state.world, scavenger_pid, 0, 0)
    World.add_robot(state.world, scavenger_pid2, 1, 0)

    {:ok, map} = World.get_map(state.world)
    assert(
      map ==
      [
        [scavenger_pid, scavenger_pid2, :desert],
        [:desert, :desert, :desert],
        [:desert, :desert, :desert]
      ]
    )
  end

  test "add scrap on the map", state do
    World.add_scrap(state.world, 0, 0);

    {:ok, map} = World.get_map(state.world)
    assert(
      map ==
        [
          [:scrap, :desert, :desert],
          [:desert, :desert, :desert],
          [:desert, :desert, :desert]
        ]
    )
  end

end
