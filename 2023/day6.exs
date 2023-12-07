#!/usr/bin/env elixir
defmodule Day6 do
  def part1(input) do
    input
    |> Enum.map(fn line -> Enum.map(line, &String.to_integer/1) end)
    |> Enum.zip()
    |> Enum.map(fn {race, record} -> count_winning(race, record) end)
    |> Enum.product()
  end

  def count_winning(race, record) do
    scores = for n <- 1..div(race, 2), do: n * (race - n)
    [_middle | rev_no_middle] = reversed = Enum.reverse(scores)
    scores = scores ++ if rem(race, 2) == 1, do: reversed, else: rev_no_middle
    Enum.count(scores, fn score -> score > record end)
  end

  def part2(input) do
    [race, record] = Enum.map(input, fn line -> line |> Enum.join() |> String.to_integer() end)
    count_winning(race, record)
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split()
        |> Enum.drop(1)
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
    IO.puts("Usage: elixir day6.exs input_filename")
  end
end

Day6.run()
