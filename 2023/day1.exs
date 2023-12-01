defmodule Day1 do
  def part1(input) do
    input
    |> Enum.map(fn line ->
      numbers = String.replace(line, ~r/[^1-9]/, "")
      String.to_integer(String.first(numbers) <> String.last(numbers))
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(fn line ->
      numbers =
        line
        |> string_to_digits()
        |> String.replace(~r/[^1-9]/, "")

      String.to_integer(String.first(numbers) <> String.last(numbers))
    end)
    |> Enum.sum()
  end

  def string_to_digits(line) do
    line
    |> String.replace("one", "o1e")
    |> String.replace("two", "t2o")
    |> String.replace("three", "t3e")
    |> String.replace("four", "f4r")
    |> String.replace("five", "f5e")
    |> String.replace("six", "s6x")
    |> String.replace("seven", "s7n")
    |> String.replace("eight", "e8t")
    |> String.replace("nine", "n9e")
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      String.split(input, "\n", trim: true)
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
    IO.puts("#{result}\n")
  end

  defp format_time(μsec) when μsec < 1_000, do: "#{μsec}μs"
  defp format_time(μsec) when μsec < 1_000_000, do: "#{μsec / 1000}ms"
  defp format_time(μsec), do: "#{μsec / 1_000_000}s"

  defp print_usage do
    IO.puts("Usage: elixir day1.exs input_filename")
  end
end

Day1.run()
