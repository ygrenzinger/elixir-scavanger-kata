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
    {:error, _msg} = World.start_link(size)
  end

  test "add a robot", state do
    {:ok, scavenger_pid} = Scavenger.start_link(%{world: state.world})
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
    {:ok, scavenger_pid} = Scavenger.start_link(%{world: state.world})
    {:ok, scavenger_pid2} = Scavenger.start_link(%{world: state.world})
    World.add_robot(state.world, scavenger_pid, 0, 0)

    result = World.add_robot(state.world, scavenger_pid2, 0, 0)

    assert(
      result ==
        {:error, "you should call Elon and explain why you loose 100M DOGE. "}
    )
  end

  test "add a second robot not to the same place of the first one", state do
    {:ok, scavenger_pid} = Scavenger.start_link(%{world: state.world})
    {:ok, scavenger_pid2} = Scavenger.start_link(%{world: state.world})
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
    World.add_scrap(state.world, 0, 0)

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

  test "move robot to the north", state do
    {:ok, scavenger_pid} = Scavenger.start_link(%{world: state.world})
    World.add_robot(state.world, scavenger_pid, 1, 1)

    Scavenger.move(scavenger_pid, :north)

    {:ok, map} = World.get_map(state.world)

    assert(
      map ==
        [
          [:desert, scavenger_pid, :desert],
          [:desert, :desert, :desert],
          [:desert, :desert, :desert]
        ]
    )
  end

  test "move robot to the south", state do
    {:ok, scavenger_pid} = Scavenger.start_link(%{world: state.world})
    World.add_robot(state.world, scavenger_pid, 1, 1)

    Scavenger.move(scavenger_pid, :south)

    {:ok, map} = World.get_map(state.world)

    assert(
      map ==
        [
          [:desert, :desert, :desert],
          [:desert, :desert, :desert],
          [:desert, scavenger_pid, :desert]
        ]
    )
  end

  test "move robot to the east", state do
    {:ok, scavenger_pid} = Scavenger.start_link(%{world: state.world})
    World.add_robot(state.world, scavenger_pid, 1, 1)

    Scavenger.move(scavenger_pid, :east)

    {:ok, map} = World.get_map(state.world)

    assert(
      map ==
        [
          [:desert, :desert, :desert],
          [:desert, :desert, scavenger_pid],
          [:desert, :desert, :desert]
        ]
    )
  end

  test "move robot to the west", state do
    {:ok, scavenger_pid} = Scavenger.start_link(%{world: state.world})
    World.add_robot(state.world, scavenger_pid, 1, 1)

    Scavenger.move(scavenger_pid, :west)

    {:ok, map} = World.get_map(state.world)

    assert(
      map ==
        [
          [:desert, :desert, :desert],
          [scavenger_pid, :desert, :desert],
          [:desert, :desert, :desert]
        ]
    )
  end

  test "the world is a donut, go north", state do
    {:ok, scavenger_pid} = Scavenger.start_link(%{world: state.world})
    World.add_robot(state.world, scavenger_pid, 1, 0)

    Scavenger.move(scavenger_pid, :north)

    {:ok, map} = World.get_map(state.world)

    assert(
      map ==
        [
          [:desert, :desert, :desert],
          [:desert, :desert, :desert],
          [:desert, scavenger_pid, :desert]
        ]
    )
  end

  test "the world is a donut, go south", state do
    {:ok, scavenger_pid} = Scavenger.start_link(%{world: state.world})
    World.add_robot(state.world, scavenger_pid, 1, 2)

    Scavenger.move(scavenger_pid, :south)

    {:ok, map} = World.get_map(state.world)

    assert(
      map ==
        [
          [:desert, scavenger_pid, :desert],
          [:desert, :desert, :desert],
          [:desert, :desert, :desert]
        ]
    )
  end

  test "the world is a donut, go east", state do
    {:ok, scavenger_pid} = Scavenger.start_link(%{world: state.world})
    World.add_robot(state.world, scavenger_pid, 2, 1)

    Scavenger.move(scavenger_pid, :east)

    {:ok, map} = World.get_map(state.world)

    assert(
      map ==
        [
          [:desert, :desert, :desert],
          [scavenger_pid, :desert, :desert],
          [:desert, :desert, :desert]
        ]
    )
  end

  test "the world is a donut, go west", state do
    {:ok, scavenger_pid} = Scavenger.start_link(%{world: state.world})
    World.add_robot(state.world, scavenger_pid, 0, 1)

    Scavenger.move(scavenger_pid, :west)

    {:ok, map} = World.get_map(state.world)

    assert(
      map ==
        [
          [:desert, :desert, :desert],
          [:desert, :desert, scavenger_pid],
          [:desert, :desert, :desert]
        ]
    )
  end

  test "can't go on scavenger", state do
    {:ok, scavenger1} = Scavenger.start_link(%{world: state.world})
    {:ok, scavenger2} = Scavenger.start_link(%{world: state.world})
    World.add_robot(state.world, scavenger1, 1, 1)
    World.add_robot(state.world, scavenger2, 0, 1)

    {:error, "can't move there"} = Scavenger.move(scavenger2, :east)

    {:ok, map} = World.get_map(state.world)

    assert(
      map ==
        [
          [:desert, :desert, :desert],
          [scavenger2, scavenger1, :desert],
          [:desert, :desert, :desert]
        ]
    )
  end

  test "scavenger has a durability", state do
    {:ok, scavenger} = Scavenger.start_link(%{world: state.world})

    durability = Scavenger.get_durability(scavenger)

    assert durability == 10
  end

  test "scavenger harvest a scrap", state do
    {:ok, scavenger} = Scavenger.start_link(%{world: state.world})
    World.add_robot(state.world, scavenger, 1, 1)
    World.add_scrap(state.world, 1, 2)

    {:ok, scrap} = Scavenger.move(scavenger, :south)

    durability = Scavenger.get_durability(scavenger)
    assert durability == 20
  end

  test "Scavenger should go the the nearst scrap", state do
    {:ok, scavenger} = Scavenger.start_link(%{world: state.world})
    World.add_robot(state.world, scavenger, 1, 1)
    World.add_scrap(state.world, 1, 0)

    :ok = Scavenger.move_to_scrap(scavenger)

    {:ok, map} = World.get_map(state.world)

    assert(
      map ==
        [
          [:desert, scavenger, :desert],
          [:desert, :desert, :desert],
          [:desert, :desert, :desert]
        ]
    )

    assert Scavenger.get_durability(scavenger) == 20
  end
end
