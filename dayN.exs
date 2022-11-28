defmodule DayREPLACE_ME do
  def part1(input) do
    input
  end

  def part2(_input) do
    :ok
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
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
  defp format_time(μsec) when μsec < 60_000_000, do: "#{μsec / 1_000_000}s"

  defp format_time(μsec) when μsec < 3_660_000_000 do
    total_secs = round(μsec / 1_000_000)
    mins = div(total_secs, 60)
    secs = rem(total_secs, 60)
    "#{mins}m#{secs}s"
  end

  defp print_usage do
    IO.puts("Usage: elixir dayREPLACE_ME.exs input_filename")
  end
end

# DayREPLACE_ME.run()
