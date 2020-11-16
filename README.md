# Scavanging Robots

## Features

- a robot can move forward on the map (advancing on the square in the direction it face)
- a robot can turn left or right
- a robot has a durability score of 10
- a robot can scavange scrap on the map
- the map has a size and is "round" aka a robot moving at the top appears at the bottom and at the left appears at the right (and vice versa)
- a robot can fight or collaborate with another robot when they meet on the same  square with the following rules:

| Stategy     | Attack | Collaborate |
| ----------- | ------ | ----------- |
| Attack      | -2,-2  | 2,-2        |
| Collaborate | -2,2   | 1,1         |

Inspired by some [Nash equilibrium and game thoery](https://owlcation.com/stem/nashequilibrium) :D 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `treasure_hunter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:treasure_hunter, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)

