#!/usr/bin/env elixir
defmodule Day2 do
  def part1(reports) do
    Enum.count(reports, &check_report/1)
  end

  def check_report([a, b | _]) when abs(b - a) not in [1, 2, 3], do: false
  def check_report([a, b | rest]), do: check_report([b | rest], b - a)
  def check_report([_], _dir), do: true

  def check_report([a, b | rest], dir) do
    new_dir = b - a

    if ((dir < 0 and new_dir < 0) or (dir > 0 and new_dir > 0)) and abs(new_dir) <= 3 do
      check_report([b | rest], new_dir)
    else
      false
    end
  end

  def part2(reports) do
    Enum.count(reports, fn report ->
      Enum.find_value(0..(length(report) - 1), false, fn dampen ->
        report |> List.delete_at(dampen) |> check_report()
      end)
    end)
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> line |> String.split() |> Enum.map(&String.to_integer/1) end)
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
    IO.puts("Usage: elixir day2.exs input_filename")
  end
end

Day2.run()
