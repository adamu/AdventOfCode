#!/usr/bin/env elixir
defmodule Day1 do
  def part1({list1, list2}) do
    list1 = Enum.sort(list1)
    list2 = Enum.sort(list2)

    distances(list1, list2) |> Enum.sum()
  end

  def distances([], []), do: []
  def distances([h1 | t1], [h2 | t2]), do: [abs(h1 - h2) | distances(t1, t2)]

  def part2({list1, list2}) do
    frequencies = Enum.frequencies(list2)
    Enum.reduce(list1, 0, fn item, count -> count + item * Map.get(frequencies, item, 0) end)
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      integers =
        input
        |> String.split(["   ", "\n"], trim: true)
        |> Enum.map(&String.to_integer/1)

      list1 = Enum.take_every(integers, 2)
      list2 = Enum.take_every(tl(integers), 2)

      {list1, list2}
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
    IO.puts("#{inspect(result)}\n")
  end

  defp format_time(μsec) when μsec < 1_000, do: "#{μsec}μs"
  defp format_time(μsec) when μsec < 1_000_000, do: "#{μsec / 1000}ms"
  defp format_time(μsec), do: "#{μsec / 1_000_000}s"

  defp print_usage do
    IO.puts("Usage: elixir day1.exs input_filename")
  end
end

Day1.run()
