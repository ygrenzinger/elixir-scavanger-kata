defmodule WorldTest do
  use ExUnit.Case

  test "should create world as a process" do
    size = %{height: 3, width: 3}
    {:ok, world} = World.start_link(size)
    assert(is_pid(world))
  end

  test "should create world full of :desert of 3x3" do
    size = %{height: 3, width: 3}
    {:ok, world} = World.start_link(size)

    {:ok, map} = World.get_map(world)

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

  test "add a robot" do
    size = %{height: 3, width: 3}
    {:ok, world} = World.start_link(size)

    {:ok, scavenger_pid} = Scavenger.start_link()
    World.add_robot(world, scavenger_pid, 0, 0)

    {:ok, map} = World.get_map(world)
    assert(
      map ==
      [
        [scavenger_pid, :desert, :desert],
        [:desert, :desert, :desert],
        [:desert, :desert, :desert]
      ]
    )
  end
end