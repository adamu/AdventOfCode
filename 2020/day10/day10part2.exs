defmodule Day10Part2 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> count_arrangements()
    |> IO.puts()
  end

  def count_arrangements(list), do: count_arrangements(%{0 => 1}, [0 | Enum.sort(list)])

  def count_arrangements(arrs_to, [last]), do: arrs_to[last]

  def count_arrangements(arrs_to, [current | rest]) do
    rest
    |> Enum.take(3)
    |> count_reachable(current, arrs_to)
    |> count_arrangements(rest)
  end

  def count_reachable([], _a, arrs_to), do: arrs_to

  def count_reachable([b | rest], a, arrs_to) when b - a <= 3 do
    arrs_to = Map.update(arrs_to, b, arrs_to[a], &(&1 + arrs_to[a]))
    count_reachable(rest, a, arrs_to)
  end

  def count_reachable([_b | rest], a, arrs_to), do: count_reachable(rest, a, arrs_to)
end

Day10Part2.run()
