#!/usr/bin/env elixir
defmodule Day2 do
  def part1(input) do
    input
    |> Map.filter(fn {_id, cubes} ->
      cubes["red"] <= 12 and cubes["green"] <= 13 and cubes["blue"] <= 14
    end)
    |> Map.keys()
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(fn {_id, cubes} -> cubes |> Map.values() |> Enum.product() end)
    |> Enum.sum()
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.split("\n", trim: true)
      |> Map.new(fn line ->
        ["Game " <> id | rounds] = String.split(line, [": ", "; "])

        rounds =
          rounds
          |> Enum.map(&parse_round/1)
          |> Enum.reduce(
            %{"red" => 0, "green" => 0, "blue" => 0},
            &Map.merge(&1, &2, fn _colour, count1, count2 -> max(count1, count2) end)
          )

        {String.to_integer(id), rounds}
      end)
    else
      _ -> :error
    end
  end

  def parse_round(round) do
    round
    |> String.split([", ", " "])
    |> Enum.chunk_every(2)
    |> Map.new(fn [number, colour] -> {colour, String.to_integer(number)} end)
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
    IO.puts("Usage: elixir day2.exs input_filename")
  end
end

Day2.run()
