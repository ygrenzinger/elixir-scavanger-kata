defmodule ScavangerKataTest do
  use ExUnit.Case

  test "Create the simplest world ever" do
    WorldAgent.create(1, 1)

    assert WorldAgent.print() == """
           _
           """
  end

  test "Add robot in the world" do
    WorldAgent.create(2, 3)
    {_, robot_pid} = RobotScavangerAgent.create()

    WorldAgent.add_robot(robot_pid, %{x: 0, y: 1})

    assert WorldAgent.print() == """
           __
           R_
           __
           """
  end

  test "Add two robots in the world" do
    WorldAgent.create(2, 3)
    {_, first_robot_pid} = RobotScavangerAgent.create()
    {_, second_robot_pid} = RobotScavangerAgent.create()

    WorldAgent.add_robot(first_robot_pid, %{x: 0, y: 1})
    WorldAgent.add_robot(second_robot_pid, %{x: 0, y: 2})

    assert WorldAgent.print() == """
           __
           R_
           R_
           """
  end

  test "A robot can't move if there is another robot at existing position" do
    WorldAgent.create(2, 3)
    {_, first_robot_pid} = RobotScavangerAgent.create()
    {_, second_robot_pid} = RobotScavangerAgent.create()

    WorldAgent.add_robot(first_robot_pid, %{x: 0, y: 1})
    WorldAgent.add_robot(second_robot_pid, %{x: 0, y: 2})

    WorldAgent.robot_move_forward(second_robot_pid)
    WorldAgent.robot_move_forward(second_robot_pid)

    assert WorldAgent.print() == """
           __
           R_
           R_
           """
  end

  test "Move robot in the world" do
    WorldAgent.create(2, 3)
    {_, robot_pid} = RobotScavangerAgent.create()

    WorldAgent.add_robot(robot_pid, %{x: 0, y: 1})

    assert WorldAgent.print() == """
           __
           R_
           __
           """

    WorldAgent.robot_move_forward(robot_pid)

    assert WorldAgent.print() == """
           R_
           __
           __
           """
  end

  test "Rotate and move robot in the world" do
    WorldAgent.create(2, 3)
    {_, robot_pid} = RobotScavangerAgent.create()

    WorldAgent.add_robot(robot_pid, %{x: 1, y: 1})

    robot_pid
    |> RobotScavangerAgent.turn_right()
    |> RobotScavangerAgent.turn_right()
    |> RobotScavangerAgent.turn_right()
    |> WorldAgent.robot_move_forward()

    assert WorldAgent.print() == """
           __
           R_
           __
           """
  end

  test "Add two robots in the world and the first robot move forward" do
    WorldAgent.create(2, 3)
    {_, first_robot_pid} = RobotScavangerAgent.create()
    {_, second_robot_pid} = RobotScavangerAgent.create()

    WorldAgent.add_robot(first_robot_pid, %{x: 0, y: 1})
    WorldAgent.add_robot(second_robot_pid, %{x: 0, y: 2})

    WorldAgent.robot_move_forward(first_robot_pid)

    assert WorldAgent.print() == """
           R_
           __
           R_
           """
  end

  test "The world is a donut" do
    WorldAgent.create(3, 3)
    {_, robot_pid} = RobotScavangerAgent.create()

    WorldAgent.add_robot(robot_pid, %{x: 0, y: 0})

    WorldAgent.robot_move_forward(robot_pid)
    RobotScavangerAgent.turn_left(robot_pid)
    WorldAgent.robot_move_forward(robot_pid)

    assert WorldAgent.print() == """
           ___
           ___
           __R
           """
  end

  test "A robot moving on a scrap will take it and increase its durability" do
    WorldAgent.create(2, 3)
    {_, robot_pid} = RobotScavangerAgent.create()

    assert RobotScavangerAgent.get_durability(robot_pid) == 10

    WorldAgent.add_robot(robot_pid, %{x: 1, y: 1})
    WorldAgent.add_scrap(10, %{x: 1, y: 0})

    WorldAgent.robot_move_forward(robot_pid)

    assert RobotScavangerAgent.get_durability(robot_pid) == 20
  end

  test "A second robot moving after a previous robot to a scrap position could not take it because it's no longer there." do
    WorldAgent.create(2, 3)
    {_, robot_pid} = RobotScavangerAgent.create()
    {_, robot_2_pid} = RobotScavangerAgent.create()
    robot_2_pid |> RobotScavangerAgent.turn_left()

    WorldAgent.add_robot(robot_pid, %{x: 1, y: 1})
    WorldAgent.add_robot(robot_2_pid, %{x: 2, y: 0})
    WorldAgent.add_scrap(10, %{x: 1, y: 0})

    WorldAgent.robot_move_forward(robot_pid)
    WorldAgent.robot_move_forward(robot_pid)
    WorldAgent.robot_move_forward(robot_2_pid)

    assert RobotScavangerAgent.get_durability(robot_pid) == 20
    assert RobotScavangerAgent.get_durability(robot_2_pid) == 10
  end

  test "The robot knows location of a scrap and try to pick it" do
    WorldAgent.create(3, 3)
    {_, robot_pid} = RobotScavangerAgent.create()
    WorldAgent.add_robot(robot_pid, %{x: 0, y: 0})
    WorldAgent.add_scrap(10, %{x: 2, y: 2})
    assert WorldAgent.is_scrap_at(%{x: 2, y: 2}) == true

    RobotScavangerAgent.do_stuff(robot_pid)

    assert WorldAgent.get_robot_position(robot_pid) == %{x: 2, y: 2}
    assert RobotScavangerAgent.get_durability(robot_pid) == 20
    assert WorldAgent.is_scrap_at(%{x: 2, y: 2}) == false
  end

  test "The robot knows location of scraps and try to pick" do
    WorldAgent.create(8, 8)
    {_, robot_pid} = RobotScavangerAgent.create()
    WorldAgent.add_robot(robot_pid, %{x: 2, y: 2})
    WorldAgent.add_scrap(10, %{x: 0, y: 0})

    RobotScavangerAgent.do_stuff(robot_pid)

    assert WorldAgent.get_robot_position(robot_pid) == %{x: 0, y: 0}
    assert RobotScavangerAgent.get_durability(robot_pid) == 20
  end

  test "The robot knows location of scraps and try to pick all of it" do
    WorldAgent.create(8, 8)
    {_, robot_pid} = RobotScavangerAgent.create()
    WorldAgent.add_robot(robot_pid, %{x: 2, y: 2})
    WorldAgent.add_scrap(10, %{x: 0, y: 0})
    WorldAgent.add_scrap(10, %{x: 5, y: 7})

    RobotScavangerAgent.do_stuff(robot_pid)

    # assert WorldAgent.get_robot_position(robot_pid) == %{x: 0, y: 0}
    assert RobotScavangerAgent.get_durability(robot_pid) == 30
  end
  
  test "The robots will got to nearest scrap" do
    IO.puts "The robots will got to nearest scrap"

    WorldAgent.create(100, 100)
    
    {_, robot_pid} = RobotScavangerAgent.create()
    {_, robot_2_pid} = RobotScavangerAgent.create()

    WorldAgent.add_robot(robot_pid, %{x: 0, y: 0})
    WorldAgent.add_robot(robot_2_pid, %{x: 90, y: 90})

    WorldAgent.add_scrap(10, %{x: 10, y: 7})
    WorldAgent.add_scrap(10, %{x: 80, y: 82})

    robot_task1 = RobotScavangerAgent.search_and_peek(robot_pid)
    robot_task2 = RobotScavangerAgent.search_and_peek(robot_2_pid)

    Task.await_many([robot_task1, robot_task2])

    # assert WorldAgent.no_more_scrap?()
    assert RobotScavangerAgent.get_durability(robot_pid) == 20
    assert RobotScavangerAgent.get_durability(robot_2_pid) == 20
  end

end
