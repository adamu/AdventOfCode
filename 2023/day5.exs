#!/usr/bin/env elixir
defmodule Day5 do
  def part1({seeds, maps}) do
    seeds
    |> Enum.map(fn seed -> Enum.reduce(maps, seed, &lookup/2) end)
    |> Enum.min()
  end

  def lookup([], item), do: item

  def lookup([{source, offset} | rest], item) do
    if item in source do
      item + offset
    else
      lookup(rest, item)
    end
  end

  def part2({seeds, maps}) do
    seed_ranges =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, len] -> start..(start + len - 1) end)

    maps
    |> Enum.reduce(seed_ranges, &process_ranges/2)
    |> Enum.min_by(& &1.first)
    |> then(& &1.first)
  end

  def process_ranges(_map_ranges, []), do: []

  def process_ranges(map_ranges, [item_range | rest]) do
    overlap =
      Enum.find(map_ranges, fn {source, _offset} -> not Range.disjoint?(source, item_range) end)

    case overlap do
      nil ->
        [item_range | process_ranges(map_ranges, rest)]

      {source, offset} ->
        to_shift = max(source.first, item_range.first)..min(source.last, item_range.last)

        # ugh. Tidy this up
        remainders =
          List.flatten([
            if(item_range.first < source.first,
              do: [item_range.first..(source.first - 1)],
              else: []
            ),
            if(item_range.last > source.last, do: [(source.last + 1)..item_range.last], else: [])
          ])

        [Range.shift(to_shift, offset) | process_ranges(map_ranges, remainders ++ rest)]
    end
  end

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
            {source..(source + offset), dest - source}
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
    IO.puts("#{inspect(result, charlists: :as_lists)}\n")
  end

  defp format_time(μsec) when μsec < 1_000, do: "#{μsec}μs"
  defp format_time(μsec) when μsec < 1_000_000, do: "#{μsec / 1000}ms"
  defp format_time(μsec), do: "#{μsec / 1_000_000}s"

  defp print_usage do
    IO.puts("Usage: elixir day5.exs input_filename")
  end
end

Day5.run()
