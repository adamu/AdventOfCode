defmodule Day5 do
  def part1(input) do
    Enum.count(input, &nice?/1)
  end

  def nice?(str) do
    at_least_three_vowels(str) and
      twice_in_a_row(str) and
      not String.contains?(str, ["ab", "cd", "pq", "xy"])
  end

  def at_least_three_vowels(str) do
    str
    |> String.graphemes()
    |> Enum.frequencies()
    |> Map.take(["a", "e", "i", "o", "u"])
    |> Map.values()
    |> Enum.sum()
    |> Kernel.>=(3)
  end

  def twice_in_a_row(<<x, x, _::binary>>), do: true
  def twice_in_a_row(<<_x, rest::binary>>), do: twice_in_a_row(rest)
  def twice_in_a_row(<<>>), do: false

  def part2(input) do
   Enum.count(input, &nice2?/1)
  end

  def nice2?(str) do
    pairs = pairs(str)
    uniq = MapSet.new(pairs)
    length(pairs) > MapSet.size(uniq) and sandwich(str)
  end

  def pairs(str, prev \\ nil)
  def pairs(<<x, x, rest::binary>>, <<x, x>>), do: pairs(<<x, rest::binary>>)
  def pairs(<<x, y, rest::binary>>, _prev), do: [<<x, y>> | pairs(<<y, rest::binary>>, <<x, y>>)]
  def pairs(<<_>>, _prev), do: []

  def sandwich(<<x, y, x, _rest::binary>>), do: true
  def sandwich(<<_x, y, z, rest::binary>>), do: sandwich(<<y, z, rest::binary>>)
  def sandwich(_), do: false

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.split("\n", trim: true)
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
    IO.puts("Usage: elixir day5.exs input_filename")
  end
end

Day5.run()
