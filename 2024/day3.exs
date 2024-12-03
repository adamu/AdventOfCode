#!/usr/bin/env elixir
defmodule Day3 do
  def part1(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, input, capture: :all_but_first)
    |> Enum.map(fn [a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end

  def part2(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)|(do\(\))|(don't\(\))/, input, capture: :all_but_first)
    |> Enum.reduce({0, :process}, fn
      ["", "", "do()"], {sum, _} -> {sum, :process}
      ["", "", "", "don't()"], {sum, _} -> {sum, :skip}
      _, {sum, :skip} -> {sum, :skip}
      [a, b], {sum, :process} -> {sum + String.to_integer(a) * String.to_integer(b), :process}
    end)
    |> elem(0)
  end

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
    IO.puts("#{inspect(result)}\n")
  end

  defp format_time(μsec) when μsec < 1_000, do: "#{μsec}μs"
  defp format_time(μsec) when μsec < 1_000_000, do: "#{μsec / 1000}ms"
  defp format_time(μsec), do: "#{μsec / 1_000_000}s"

  defp print_usage do
    IO.puts("Usage: elixir day3.exs input_filename")
  end
end

Day3.run()
