#!/usr/bin/env elixir
defmodule Day3 do
  def part1(_input) do
    # for each number, check around its edges to see if there's a symbol
    fn {{x, y}, number, length}, acc ->
      top = for x <- (x - 1)..(x + length), do: {x, y - 1}
      bottom = for x <- (x - 1)..(x + length), do: {x, y + 1}
      box = [{x - 1, y}, {x + length, y}] ++ top ++ bottom
      if part_number?(box), do: [number | acc], else: acc
    end
    |> :ets.foldl(_acc = [], :numbers)
    |> Enum.sum()
  end

  def part_number?([]), do: false

  def part_number?([coord | rest]) do
    case :ets.lookup(:symbols, coord) do
      [_symbol] -> true
      [] -> part_number?(rest)
    end
  end

  def part2(_input) do
    :ok
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      :ets.new(:numbers, [:named_table])
      :ets.new(:symbols, [:named_table])
      parse_schematic(input, _x = 0, _y = 0)
    else
      _ -> :error
    end
  end

  def parse_schematic("", _x, _y), do: :ok
  def parse_schematic("." <> rest, x, y), do: parse_schematic(rest, x + 1, y)
  def parse_schematic("\n" <> rest, _x, y), do: parse_schematic(rest, 0, y + 1)

  def parse_schematic(<<digit::utf8>> <> rest, x, y) when digit in ?0..?9 do
    {number, length, rest} = take_digits(<<digit::utf8>> <> rest, "", 0)
    :ets.insert(:numbers, {{x, y}, number, length})
    parse_schematic(rest, x + length, y)
  end

  def parse_schematic(<<symbol::utf8>> <> rest, x, y) do
    :ets.insert(:symbols, {{x, y}, <<symbol::utf8>>})
    parse_schematic(rest, x + 1, y)
  end

  def take_digits(<<digit::utf8>> <> rest, digits, count) when digit in ?0..?9,
    do: take_digits(rest, digits <> <<digit::utf8>>, count + 1)

  def take_digits(rest, digits, count), do: {String.to_integer(digits), count, rest}

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

# Day3.run()
