#!/usr/bin/env elixir
defmodule Day5 do
  def part1({seeds, maps}) do
    seeds
    |> Enum.map(fn seed -> Enum.reduce(maps, seed, &lookup/2) end)
    |> Enum.min()
  end

  def lookup([], item), do: item

  def lookup([{source, dest} | rest], item) do
    if item in source do
      dest + item - source.first
    else
      lookup(rest, item)
    end
  end

  def part2(_input) do
    :ok
  end

  # dest range start
  # source range start
  # length
  # no map = same number

  # could brute force it by building a map
  # but the ranges are huge, so that won't work
  # actually need to find if in a range

  # given a source
  # 1) check if it's in a range
  # 2) if it is, follow the rule, otherwise same number
  # 3) follow path
  # well it's mlogn but it should work?
  # store a list of ranges
  # check each seed to see if it's in the range, if it is, follow it, if not, name number
  # we could binsearch the range but let's just do it linear for now, there aren't many seeds
  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      ["seeds: " <> seeds | maps] = String.split(input, "\n\n")
      seeds = seeds |> String.split() |> Enum.map(&String.to_integer/1)

      maps =
        Enum.map(maps, fn line ->
          [_header, _map | items] = String.split(line)

          items
          |> Enum.map(&String.to_integer/1)
          |> Enum.chunk_every(3)
          |> Enum.map(fn [dest, source, offset] ->
            {source..(source + offset), dest}
          end)
        end)

      {seeds, maps}
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
    IO.puts("Usage: elixir day5.exs input_filename")
  end
end

# Day5.run()
