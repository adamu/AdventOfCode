defmodule Day12Part1 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(fn <<action::binary-1>> <> value -> {action, String.to_integer(value)} end)
    |> Enum.reduce({0, 0, {1, 0}}, &process/2)
    |> manhattan_distance()
    |> IO.puts()
  end

  def process({"N", value}, {x, y, direction}), do: {x, y + value, direction}
  def process({"S", value}, {x, y, direction}), do: {x, y - value, direction}
  def process({"E", value}, {x, y, direction}), do: {x + value, y, direction}
  def process({"W", value}, {x, y, direction}), do: {x - value, y, direction}
  def process({"L", value}, {x, y, direction}), do: {x, y, turn_left(direction, value)}
  def process({"R", value}, {x, y, direction}), do: {x, y, turn_right(direction, value)}
  def process({"F", value}, {x, y, {vx, vy}}), do: {x + vx * value, y + vy * value, {vx, vy}}

  def turn_left(direction, 0), do: direction
  def turn_left({vx, vy}, degrees), do: turn_left({-vy, vx}, degrees - 90)

  def turn_right(direction, 0), do: direction
  def turn_right({vx, vy}, degrees), do: turn_right({vy, -vx}, degrees - 90)

  def manhattan_distance({x, y, _}), do: abs(x) + abs(y)
end

Day12Part1.run()
