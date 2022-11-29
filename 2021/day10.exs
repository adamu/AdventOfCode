defmodule Day10 do
  def part1(input) do
    input
    |> Enum.map(&parse_line(&1, []))
    |> Enum.filter(&match?({:corrupted, _}, &1))
    |> Enum.map(fn {:corrupted, char} -> score(char) end)
    |> Enum.sum()
  end

  def parse_line(_, {:corrupted, char}), do: {:corrupted, char}
  def parse_line("", _), do: :incomplete
  def parse_line(<<char::utf8, rest::binary>>, []), do: parse_line(rest, [char])

  def parse_line(<<char::utf8, next::binary>>, [prev | popped] = stack) do
    stack =
      case char do
        char when char in '([{<' -> [char | stack]
        ?) when prev == ?( -> popped
        ?] when prev == ?[ -> popped
        ?} when prev == ?{ -> popped
        ?> when prev == ?< -> popped
        char -> {:corrupted, char}
      end

    parse_line(next, stack)
  end

  defp score(?)), do: 3
  defp score(?]), do: 57
  defp score(?}), do: 1197
  defp score(?>), do: 25137

  def part2(_input) do
    :ok
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
    IO.puts("Usage: elixir day10.exs input_filename")
  end
end

# Day10.run()
