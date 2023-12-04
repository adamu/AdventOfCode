#!/usr/bin/env elixir
defmodule Day4 do
  def part1(input) do
    input
    |> Enum.map(fn 0 -> 0; num_winners -> 2 ** (num_winners - 1) end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(fn num_winners -> {_num_copies = 1, num_winners} end)
    |> copy()
    |> Enum.sum()
  end

  def copy([]), do: []

  def copy([{num_copies, num_winners} | rest]) do
    {to_copy, left_alone} = Enum.split(rest, num_winners)

    copied =
      Enum.map(to_copy, fn {child_num_copies, num_winners} ->
        {num_copies + child_num_copies, num_winners}
      end)

    [num_copies | copy(copied ++ left_alone)]
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [_card_id, winning, have] = String.split(line, [": ", " | "])

        winning = winning |> String.split(" ", trim: true) |> MapSet.new()
        have = have |> String.split(" ", trim: true) |> MapSet.new()

        MapSet.intersection(winning, have) |> MapSet.size()
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
    IO.puts("Usage: elixir day4.exs input_filename")
  end
end

Day4.run()
