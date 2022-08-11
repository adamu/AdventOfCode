defmodule Day12Part2 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(fn <<action::binary-1>> <> value -> {action, String.to_integer(value)} end)
    |> Enum.reduce({{0, 0}, {10, 1}}, &process/2)
    |> manhattan_distance()
    |> IO.puts()
  end

  def process({"N", value}, {boat, {vx, vy}}), do: {boat, {vx, vy + value}}
  def process({"S", value}, {boat, {vx, vy}}), do: {boat, {vx, vy - value}}
  def process({"E", value}, {boat, {vx, vy}}), do: {boat, {vx + value, vy}}
  def process({"W", value}, {boat, {vx, vy}}), do: {boat, {vx - value, vy}}
  def process({"L", value}, {boat, waypoint}), do: {boat, rotate_left(waypoint, value)}
  def process({"R", value}, {boat, waypoint}), do: {boat, rotate_right(waypoint, value)}
  def process({"F", value}, {{x, y}, {vx, vy}}), do: {{x + vx * value, y + vy * value}, {vx, vy}}

  def rotate_left(waypoint, 0), do: waypoint
  def rotate_left({vx, vy}, degrees), do: rotate_left({-vy, vx}, degrees - 90)

  def rotate_right(waypoint, 0), do: waypoint
  def rotate_right({vx, vy}, degrees), do: rotate_right({vy, -vx}, degrees - 90)

  def manhattan_distance({{x, y}, _}), do: abs(x) + abs(y)
end

Day12Part2.run()
