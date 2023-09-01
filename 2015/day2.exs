defmodule Day2 do
  def part1(input) do
    input
    |> Enum.map(fn [x, y, z] ->
      a = x * y
      b = x * z
      c = y * z
      min = Enum.min([a, b, c])
      2 * (a + b + c) + min
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(fn box ->
      [x, y, z] = Enum.sort(box)
      2 * (x + y) + x * y * z
    end)
    |> Enum.sum()
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.split(["\n", "x"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(3)
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
    IO.puts("Usage: elixir day2.exs input_filename")
  end
end

Day2.run()
