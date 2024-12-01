#!/usr/bin/env elixir
defmodule Day9 do
  def part1(histories) do
    histories
    |> Enum.map(&walk/1)
    |> Enum.sum()
  end

  def walk(history) do
    case Enum.uniq(history) do
      [last] -> last
      _ -> List.last(history) + walk(diff(history))
    end
  end

  def diff([_]), do: []
  def diff([a, b | rest]), do: [b - a | diff([b | rest])]

  def part2(histories) do
    histories
    |> Enum.map(&walk2/1)
    |> Enum.sum()
  end

  def walk2(history) do
    case Enum.uniq(history) do
      [first] -> first
      [first | _] -> first - walk2(diff(history))
    end
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
      end)
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
    IO.puts("Usage: elixir day9.exs input_filename")
  end
end

Day9.run()
