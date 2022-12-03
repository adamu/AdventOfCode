defmodule Day3 do
  def part1(input) do
    input
    |> Enum.map(fn str ->
      size = byte_size(str)

      str
      |> String.split("", trim: true)
      |> Enum.split(div(size, 2))
    end)
    |> Enum.map(fn {a, b} -> hd(a -- a -- b) end)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  defp score(<<lower::utf8>>) when lower in ?a..?z, do: lower - ?a + 1
  defp score(<<upper::utf8>>) when upper in ?A..?Z, do: upper - ?A + 27

  def part2(input) do
    input
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.chunk_every(3)
    |> Enum.map(fn [a, b, c] ->
      d = a -- a -- b
      hd(d -- d -- c)
    end)
    |> Enum.map(&score/1)
    |> Enum.sum()
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
    IO.puts("Usage: elixir day3.exs input_filename")
  end
end

Day3.run()
