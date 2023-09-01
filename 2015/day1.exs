defmodule Day1 do
  def part1(<<>>), do: 0
  def part1(<<?(, rest::binary>>), do: 1 + part1(rest)
  def part1(<<?), rest::binary>>), do: -1 + part1(rest)

  def part2(input), do: find_basement(input, _floor = 0, _pos = 1)

  def find_basement(<<?), _::binary>>, 0, pos), do: pos
  def find_basement(<<?), rest::binary>>, floor, pos), do: find_basement(rest, floor - 1, pos + 1)
  def find_basement(<<?(, rest::binary>>, floor, pos), do: find_basement(rest, floor + 1, pos + 1)

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
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
    IO.puts("Usage: elixir day1.exs input_filename")
  end
end

Day1.run()
