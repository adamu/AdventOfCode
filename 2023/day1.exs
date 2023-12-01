defmodule Day1 do
  def part1(input) do
    input
    |> Enum.map(fn line ->
      numbers = filter_digits(line)
      String.to_integer(String.first(numbers) <> String.last(numbers))
    end)
    |> Enum.sum()
  end

  def filter_digits(<<>>), do: <<>>
  def filter_digits(<<x, rest::binary>>) when x in ?1..?9, do: <<x>> <> filter_digits(rest)
  def filter_digits(<<_, rest::binary>>), do: filter_digits(rest)

  def part2(input) do
    input
    |> Enum.map(fn line ->
      numbers = filter_digits2(line)
      String.to_integer(String.first(numbers) <> String.last(numbers))
    end)
    |> Enum.sum()
  end

  def filter_digits2(<<>>), do: <<>>
  def filter_digits2(<<x, rest::binary>>) when x in ?1..?9, do: <<x>> <> filter_digits2(rest)
  def filter_digits2(<<"one", rest::binary>>), do: "1" <> filter_digits2("e" <> rest)
  def filter_digits2(<<"two", rest::binary>>), do: "2" <> filter_digits2("o" <> rest)
  def filter_digits2(<<"three", rest::binary>>), do: "3" <> filter_digits2("e" <> rest)
  def filter_digits2(<<"four", rest::binary>>), do: "4" <> filter_digits2(rest)
  def filter_digits2(<<"five", rest::binary>>), do: "5" <> filter_digits2("e" <> rest)
  def filter_digits2(<<"six", rest::binary>>), do: "6" <> filter_digits2(rest)
  def filter_digits2(<<"seven", rest::binary>>), do: "7" <> filter_digits2("n" <> rest)
  def filter_digits2(<<"eight", rest::binary>>), do: "8" <> filter_digits2("t" <> rest)
  def filter_digits2(<<"nine", rest::binary>>), do: "9" <> filter_digits2("e" <> rest)
  def filter_digits2(<<_, rest::binary>>), do: filter_digits2(rest)

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
