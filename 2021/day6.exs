defmodule Day6 do
  def part1(input) do
    input
    |> run_days(80)
    |> length()
  end

  defp run_days(school, 0), do: school
  defp run_days(school, days), do: run_days(day(school), days - 1)

  defp day(school), do: Enum.flat_map(school, &fish/1)

  defp fish(0), do: [6, 8]
  defp fish(age), do: [age - 1]

  # Implementing part 2 completely differently to avoid exponential growth

  def part2(input) do
    counts = Map.new(0..8, fn age -> {age, 0} end)

    input
    |> Enum.frequencies()
    |> Enum.into(counts)
    |> run_days2(256)
    |> Map.values()
    |> Enum.sum()
  end

  defp run_days2(counts, 0), do: counts
  defp run_days2(counts, days), do: run_days2(day2(counts), days - 1)

  defp day2(counts) do
    {breeders, counts} = Map.pop(counts, 0)

    counts
    |> Map.new(fn {age, count} -> {age - 1, count} end)
    |> Map.update(6, 0, &(&1 + breeders))
    |> Map.put(8, breeders)
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    else
      _ -> :error
    end
  end

  #######################
  # HERE BE BOILERPLATE #
  #######################

  def run do
    case input() do
      :error -> print_usage()
      input -> run_parts_with_timer(input)
    end
  end

  defp run_parts_with_timer(input) do
    run_with_timer(1, fn -> part1(input) end)
    run_with_timer(2, fn -> part2(input) end)
  end

  defp run_with_timer(part, fun) do
    {time, result} = :timer.tc(fun)
    IO.puts("Part #{part} (completed in #{format_time(time)}):\n")
    IO.puts("#{result}\n")
  end

  defp format_time(μsec) when μsec < 1_000, do: "#{μsec}μs"
  defp format_time(μsec) when μsec < 1_000_000, do: "#{μsec / 1000}ms"
  defp format_time(μsec), do: "#{μsec / 1_000_000}s"

  defp print_usage do
    IO.puts("Usage: elixir day6.exs input_filename")
  end
end

Day6.run()
