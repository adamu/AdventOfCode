defmodule Day10Part2 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> count_arrangements()
    |> IO.puts()
  end

  # Entry point. Start with one arrangement: the outlet.
  def count_arrangements(list), do: count_arrangements(%{0 => 1}, [0 | Enum.sort(list)])

  # Termination point. We've checked all the adapters. The number of arrangments
  # to the last adapter is the answer.
  def count_arrangements(arrangements, [last]), do: arrangements[last]

  # Check each adapter in turn by comparing it to the next three adapters.
  def count_arrangements(arrangements, [current | rest]) do
    count_for_adapter(current, Enum.take(rest, 3), arrangements)
    |> count_arrangements(rest)
  end

  # Compare the next three adapters to the current adapter.
  # For each checked adapter, if the joltage difference is 3 or less, we can connect them,
  # so add the number of arrangements up to the current adapter to that adapter.
  def count_for_adapter(current, next_three, arrangements) do
    Enum.reduce(next_three, arrangements, fn adapter, arrangements ->
      if adapter - current <= 3 do
        current_count = arrangements[current]
        Map.update(arrangements, adapter, current_count, &(&1 + current_count))
      else
        arrangements
      end
    end)
  end
end

Day10Part2.run()
